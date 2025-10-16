{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    ### INPUT ###
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";
      numlock_by_default = "yes";

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
