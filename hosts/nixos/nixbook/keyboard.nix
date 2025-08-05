{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards.internal = {
      ids = [
        "k:0001:0001"
        "k:18d1:5044"
        "k:18d1:5052"
        "k:0000:0000"
        "k:18d1:5050"
        "k:18d1:504c"
        "k:18d1:503c"
        "k:18d1:5030"
        "k:18d1:503d"
        "k:18d1:505b"
        "k:18d1:5057"
        "k:18d1:502b"
        "k:18d1:5061"
      ];
      settings = {
        main = {
          f1 = "back";
          f2 = "forward";
          f3 = "refresh";
          f4 = "f11";
          f5 = "scale";
          f6 = "brightnessdown";
          f7 = "brightnessup";
          f8 = "mute";
          f9 = "volumedown";
          f10 = "volumeup";
          back = "back";
          forward = "forward";
          refresh = "refresh";
          zoom = "f11";
          scale = "scale";
          brightnessdown = "brightnessdown";
          brightnessup = "brightnessup";
          mute = "mute";
          volumedown = "volumedown";
          volumeup = "volumeup";
          sleep = "coffee";
        };
        meta = {
          f1 = "f1";
          f2 = "f2";
          f3 = "f3";
          f4 = "f4";
          f5 = "f5";
          f6 = "f6";
          f7 = "f7";
          f8 = "f8";
          f9 = "f9";
          f10 = "f10";
          back = "f1";
          forward = "f2";
          refresh = "f3";
          zoom = "f4";
          scale = "f5";
          brightnessdown = "f6";
          brightnessup = "f7";
          mute = "f8";
          volumedown = "f9";
          volumeup = "f10";
          sleep = "f12";
          down = "pagedown";
          up = "pageup";
          left = "home";
          right = "end";
        };
        alt = {
          backspace = "delete";
          meta = "capslock";
          brightnessdown = "kbdillumdown";
          brightnessup = "kbdillumup";
          f6 = "kbdillumdown";
          f7 = "kbdillumup";
        };
        control = {
          f5 = "print";
          scale = "print";
        };
        controlalt = {
          backspace = "C-A-delete";
        };
      };
    };
  };

  #let
  #  cb-ucm-conf = with pkgs; alsa-ucm-conf.overrideAttrs {
  #    wttsrc = fetchFromGitHub {
  #      owner = "WeirdTreeThing";
  #      repo = "alsa-ucm-conf-cros";
  #      rev = "standalone";
  #      #rev = "6b395ae73ac63407d8a9892fe1290f191eb0315b";
  #      hash = "sha256-GHrK85DmiYF6FhEJlYJWy6aP9wtHFKkTohqt114TluI=";
  #    };
  #    unpackPhase = ''
  #      runHook preUnpack
  #      tar xf "$src"
  #      runHook postUnpack
  #    '';
  #
  #    installPhase = ''
  #      runHook preInstall
  #      mkdir -p $out/share/alsa
  #      cp -r alsa-ucm*/ucm2 $out/share/alsa
  #      runHook postInstall
  #    '';
  #  };
  #in {
  #  hardware = {
  #    pulseaudio = {
  #      package = pkgs.pulseaudioFull;
  #      extraConfig = [
  #        "set-card-profile alsa_card.platform-cht-bsw-rt5645 HiFi"
  #        "set-default-sink alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645_0__sink"
  #        "set-sink-port alsa_output.platform-cht-bsw-rt5645.HiFi__hw_chtrt5645_0__sink [Out] Speaker"
  #      ];
  #      daemon.config = {
  #        "realtime-scheduling" = "no";
  #      };
  #    };
  #  };

  #  environment = {
  #    systemPackages = [ pkgs.sof-firmware ];
  #    sessionVariables.ALSA_CONFIG_UCM2 = "${cb-ucm-conf}/share/alsa/ucm2";
  #  };

  #  services.pipewire.wireplumber.configPackages = [
  #    (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-increase-headroom.lua" ''
  #      rule = {
  #        matches = {
  #          {
  #            { "node.name", "matches", "alsa_output.*" },
  #          },
  #        },
  #        apply_properties = {
  #          ["api.alsa.headroom"] = 4096,
  #        },
  #      }
  #      table.insert(alsa_monitor.rules,rule)
  #    '')
  #  ];

  #  system.replaceRuntimeDependencies = [
  #    ({
  #      original = pkgs.alsa-ucm-conf;
  #      replacement = cb-ucm-conf;
  #    })
  #  ];
}
