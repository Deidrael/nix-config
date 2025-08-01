{
  description = "Deidrael's NixOS flake";
  # nix run nixpkgs#statix -- check .
  # Thanks to https://github.com/EmergentMind/nix-config for baseline

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # See also 'stable-packages' and 'unstable-packages' overlays at 'overlays/default.nix"
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-master.url = "github:NixOS/nixpkgs";

    hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      #url = "github:nix-community/home-manager/release-25.05";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ========= Utilities =========
    # Declarative partitioning and formatting
    #disko = {
    #  url = "github:nix-community/disko";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # Secrets management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ProtonHax
    #protonhax = {
    #  url = "github:pneg/nixpkgs/protonhax-init";
    #  #inputs.nixpkgs.follows = "nixpkgs";
    #};

    # NixAI
    #nixai.url = "github:olafkfreund/nix-ai-help";

    # Pre-commit
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ========= Personal Repositories =========
    # Private secrets repo. Authenticate via ssh and use shallow clone.
    nix-secrets = {
      url = "git+ssh://git@github.com/deidrael/nix-secrets.git?ref=main&shallow=1";
      inputs = { };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # ========= Architectures =========
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # ========== Extend lib with lib.custom ==========
      # NOTE: This approach allows lib.custom to propagate into hm
      # see: https://github.com/nix-community/home-manager/pull/3454
      lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });

    in
    {
      # ========= Overlays =========
      # Custom modifications/overrides to upstream packages
      overlays = import ./overlays { inherit inputs; };

      # ========= Host Configurations =========
      # Building configurations is available through `just rebuild` or `nixos-rebuild --flake .#hostname`
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs outputs lib;
            };
            modules = [ ./hosts/nixos/${host} ];
          };
        }) (builtins.attrNames (builtins.readDir ./hosts/nixos))
      );

      # ========= Formatting =========
      # Nix formatter available through 'nix fmt' https://github.com/NixOS/nixfmt
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      # Pre-commit checks
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks.nix { inherit inputs system pkgs; }
      );
      #
      # ========= DevShell =========
      #
      # Custom shell for bootstrapping on new hosts, modifying nix-config, and secrets management
      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        }
      );
    };
}
