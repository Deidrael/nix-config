# git is core no matter what but additional settings may could be added made in optional/foo   eg: development.nix
{
  config,
  ...
}:
{
  programs.git = {
    enable = true;
    #package = pkgs.gitAndTools.gitFull;

    settings = {
      user = {
        name = config.hostSpec.users.primary.handle;
        email = config.hostSpec.users.primary.email.gitHub;
      };
      core.pager = "delta";
      delta = {
        enable = true;
        features = [
          "side-by-side"
          "line-numbers"
          "hyperlinks"
          "line-numbers"
          "commit-decoration"
        ];
      };
      merge = {
        conflictStyle = "diff3";
        tool = "meld";
      };

      # Makes single line json diffs easier to read
      diff.json.textconv = "jq --sort-keys .";

      pull = {
        rebase = false;
      };
    };

    lfs.enable = true;

    ignores = [
      ".csvignore"
      # nix
      "*.drv"
      "result"
      # python
      "*.py?"
      "__pycache__/"
      ".venv/"
      # direnv
      ".direnv"
    ];
  };
}
