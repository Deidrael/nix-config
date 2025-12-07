{
  hostSpec,
  lib,
  ...
}:
lib.mkIf (hostSpec.desktop.hyprland.enable) {
  wayland.windowManager.hyprland.settings = {
    ### INPUT ###
    input = {
      kb_layout = "us";
      kb_variant = lib.mkDefault "";
      kb_model = lib.mkDefault "";
      kb_options = lib.mkDefault "";
      kb_rules = lib.mkDefault "";
      numlock_by_default = lib.mkDefault "yes";

      follow_mouse = 1;
      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      touchpad = {
        disable_while_typing = true;
        natural_scroll = false;
        tap-to-click = true;
      };
    };

    gesture = "3, horizontal, workspace";

    device = {
      name = "at-translated-set-2-keyboard";
      kb_model = "chromebook";
    };

  };
}
