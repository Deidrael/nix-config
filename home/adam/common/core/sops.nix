# home level sops. see hosts/common/optional/sops.nix for hosts level
{
  inputs,
  config,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets;
  homeDirectory = config.home.homeDirectory;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  sops = {
    # This is the location of the host specific age-key for ta and will to have been extracted to this location via hosts/common/core/sops.nix on the host
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";

    defaultSopsFile = "${sopsFolder}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      #placeholder for tokens that I haven't gotten to yet
      #"tokens/foo" = {
      #};
    };
  };
}
