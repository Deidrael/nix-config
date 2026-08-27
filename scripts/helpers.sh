#!/usr/bin/env bash
set -eo pipefail

### UX helpers

function red() {
	echo -e "\x1B[31m[!] $1 \x1B[0m"
	if [ -n "${2-}" ]; then
		echo -e "\x1B[31m[!] $($2) \x1B[0m"
	fi
}

function green() {
	echo -e "\x1B[32m[+] $1 \x1B[0m"
	if [ -n "${2-}" ]; then
		echo -e "\x1B[32m[+] $($2) \x1B[0m"
	fi
}

function blue() {
	echo -e "\x1B[34m[*] $1 \x1B[0m"
	if [ -n "${2-}" ]; then
		echo -e "\x1B[34m[*] $($2) \x1B[0m"
	fi
}

function yellow() {
	echo -e "\x1B[33m[*] $1 \x1B[0m"
	if [ -n "${2-}" ]; then
		echo -e "\x1B[33m[*] $($2) \x1B[0m"
	fi
}

# Ask yes or no, with yes being the default
function yes_or_no() {
	echo -en "\x1B[34m[?] $* [y/n] (default: y): \x1B[0m"
	while true; do
		read -rp "" yn
		yn=${yn:-y}
		case $yn in
		[Yy]*) return 0 ;;
		[Nn]*) return 1 ;;
		esac
	done
}

# Ask yes or no, with no being the default
function no_or_yes() {
	echo -en "\x1B[34m[?] $* [y/n] (default: n): \x1B[0m"
	while true; do
		read -rp "" yn
		yn=${yn:-n}
		case $yn in
		[Yy]*) return 0 ;;
		[Nn]*) return 1 ;;
		esac
	done
}

### SOPS helpers
nix_secrets_dir=${NIX_SECRETS_DIR:-"$(dirname "${BASH_SOURCE[0]}")/../../nix-secrets"}
SOPS_FILE="${nix_secrets_dir}/.sops.yaml"

# Updates the .sops.yaml file with a new host or user age key.
function sops_update_age_key() {
	field="$1"
	keyname="$2"
	key="$3"

	if [ ! "$field" == "hosts" ] && [ ! "$field" == "users" ]; then
		red "Invalid field passed to sops_update_age_key. Must be either 'hosts' or 'users'."
		exit 1
	fi

	# The keys section is a flat list of anchored age public keys.
	if [[ -n $(yq ".keys[] | select(anchor == \"$keyname\")" "${SOPS_FILE}") ]]; then
		green "Updating existing ${keyname} key"
		yq -i "(.keys[] | select(anchor == \"$keyname\")) = \"$key\"" "$SOPS_FILE"
	else
		green "Adding new ${keyname} key"
		yq -i ".keys += [\"$key\"] | .keys[-1] anchor = \"$keyname\"" "$SOPS_FILE"
	fi
}

# Adds the user and host to the shared.yaml creation rules
function sops_add_shared_creation_rules() {
	u="\"$1_$2\"" # quoted user_host for yaml
	h="\"$2\""    # quoted hostname for yaml

	shared_selector='.creation_rules[] | select(.path_regex == "shared\.yaml$")'
	if [[ -n $(yq "$shared_selector" "${SOPS_FILE}") ]]; then
		if [[ -z $(yq "$shared_selector.key_groups[].age[] | select(alias == $h)" "${SOPS_FILE}") ]]; then
			green "Adding $u and $h to shared.yaml rule"
			# NOTE: Split on purpose to avoid weird file corruption
			yq -i "($shared_selector).key_groups[].age += [$u, $h]" "$SOPS_FILE"
			yq -i "($shared_selector).key_groups[].age[-2] alias = $u" "$SOPS_FILE"
			yq -i "($shared_selector).key_groups[].age[-1] alias = $h" "$SOPS_FILE"
		fi
	else
		red "shared.yaml rule not found"
	fi
}

# Adds the sops/<host>.yaml creation rule using literal public keys
# (sops accepts public keys directly in key_groups; anchors are optional).
# args: user, host, user_pubkey, host_pubkey, admin_pubkey
function sops_add_host_creation_rules() {
	user="$1"
	host="$2"
	user_pubkey="$3"
	host_pubkey="$4"
	admin_pubkey="$5"

	host_selector=".creation_rules[] | select(.path_regex | contains(\"${host}\.yaml\"))"
	if [[ -z $(yq "$host_selector" "${SOPS_FILE}") ]]; then
		green "Adding new host file creation rule for ${host}"
		yq -i ".creation_rules += {\"path_regex\": \"sops/${host}\\.yaml$\", \"key_groups\": [{\"age\": [\"${user_pubkey}\", \"${host_pubkey}\", \"${admin_pubkey}\"]}]}" "$SOPS_FILE"
	else
		green "Updating existing host file creation rule for ${host}"
		yq -i "($host_selector).key_groups[].age = [\"${user_pubkey}\", \"${host_pubkey}\", \"${admin_pubkey}\"]" "$SOPS_FILE"
	fi
}

# Adds the creation rules for a host. The shared.yaml rule is managed
# separately (added when shared secrets are introduced), so it is not touched here.
function sops_add_creation_rules() {
	user="$1"
	host="$2"
	user_pubkey="$3"
	host_pubkey="$4"
	admin_pubkey="$5"
	sops_add_host_creation_rules "$user" "$host" "$user_pubkey" "$host_pubkey" "$admin_pubkey"
}

age_secret_key=""
# Generate a user age key, update the .sops.yaml entries, and return the key in age_secret_key
# args: user, hostname
function sops_generate_user_age_key() {
	target_user="$1"
	target_hostname="$2"
	key_name="${target_user}-${target_hostname}"
	green "Age key does not exist. Generating."
	user_age_key=$(age-keygen)
	readarray -t entries <<<"$user_age_key"
	age_secret_key=${entries[2]}
	public_key=$(echo "${entries[1]}" | rg key: | cut -f2 -d: | xargs)
	green "Generated age key for ${key_name}"
	# Place the anchors into .sops.yaml so other commands can reference them
	sops_update_age_key "users" "$key_name" "$public_key"

	host_pubkey=$(yq ".keys[] | select(anchor == \"${target_hostname}\")" "${SOPS_FILE}")
	admin_pubkey=$(yq '.keys[] | select(anchor == "adam")' "${SOPS_FILE}")
	sops_add_creation_rules "${target_user}" "${target_hostname}" "$public_key" "$host_pubkey" "$admin_pubkey"

	# "return" key so it can be used by caller
	export age_secret_key
}

function sops_setup_user_age_key() {
	target_user="$1"
	target_hostname="$2"

	secret_file="${nix_secrets_dir}/sops/${target_hostname}.yaml"
	config="${nix_secrets_dir}/.sops.yaml"

	# If the file already exists and we can read its age key, nothing to do.
	if [ -f "$secret_file" ] && sops --config "$config" -d --extract '["keys"]["age"]' "$secret_file" >/dev/null 2>&1; then
		green "Age key already exists for ${target_hostname}"
		return 0
	fi

	green "Generating age key and creating $secret_file"
	sops_generate_user_age_key "${target_user}" "${target_hostname}"
	mkdir -p "$(dirname "$secret_file")"
	# Write the private key into the plaintext file, then encrypt once.
	# Encryption only needs the public keys from the creation rule, so no
	# recipient private key needs to be present on this machine.
	echo "{\"keys\": {\"age\": \"${age_secret_key}\"}}" >"$secret_file"
	sops --config "$config" -e "$secret_file" >"$secret_file.enc"
	mv "$secret_file.enc" "$secret_file"
}
