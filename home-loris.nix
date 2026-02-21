{ config, pkgs, ... }:

{

  # Inside your main configuration.nix
  services.ollama = {
  enable = true;
  acceleration = "rocm";
};

  home-manager.users.loris = { pkgs, ... }: {
    imports = [ ./waybar_default.nix ];
    home.stateVersion = "25.11";

    # Cursor Configuration
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };


    # User Packages
    home.packages = with pkgs; [
      librewolf 
      discord 
      spotify 
      prismlauncher
      xfce.thunar 
      vscodium 
      thunderbird 
      fuzzel
      swww
      unzip
      zip
      qemu
      cargo
      rustc
      gcc
      libiconv
      obsidian
      virt-viewer
      blender
      ollama


      # 2. Corrected virt-manager override: Wrapped in parentheses to evaluate as one item
      (virt-manager.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
        postInstall = (oldAttrs.postInstall or "") + ''
          wrapProgram $out/bin/virt-manager \
            --set GDK_BACKEND x11
        '';
      }))
    ];


    # Hyprland Configuration
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # MONITOR SETUP: Scale is set to 1 to prevent the "zoomed" UI look
        monitor = [
          "DP-1, 3440x1440@120, 0x0, 1"
          "HDMI-A-2, 1920x1080@60, 3440x0, 1"
        ];

        "exec-once" = [
          "waybar"
          "swww-daemon"
          # This sets the wallpaper on launch with a crop resize to help with the 21:9 aspect ratio
          "sleep 1 && swww img /home/loris/Pictures/wallpaper.png --outputs DP-1 --resize crop"
          "sleep 1 && swww img /home/loris/Pictures/wallpaper.png --outputs HDMI-A-2 --resize crop"
        ];

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
        ];

        input = {
          kb_layout = "ch";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = false;
        };

        general = {
          gaps_in = 5;
          gaps_out = 0;
          border_size = 2;
          "col.active_border" = "rgba(cba6f7ee) rgba(94e2d5ee) 45deg"; # Lilac to Teal
          "col.inactive_border" = "rgba(313244aa)";
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 0.95;
          shadow.enabled = true;
          blur.enabled = true;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        "$mainMod" = "SUPER";
        
        bind = [
          "$mainMod, Q, exec, kitty"
          "$mainMod, E, exec, dolphin"
          "$mainMod, R, exec, wofi --show drun"
          "$mainMod, D, exec, fuzzel"
          "$mainMod, C, killactive"
          "$mainMod, M, exit"
          "$mainMod, V, togglefloating"
          "$mainMod, F, fullscreen, 0"
          "$mainMod SHIFT, F, fullscreen, 1"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod SHIFT, B, exec, pkill waybar && waybar"
          
          # Media keys
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
        ] ++ (
          # Workspace binds
          builtins.concatLists (builtins.genList (i:
            let
              ws = i + 1;
              key = if i == 9 then "0" else toString ws;
            in [
              "$mainMod, ${key}, workspace, ${toString ws}"
              "$mainMod SHIFT, ${key}, movetoworkspace, ${toString ws}"
            ]
          ) 10)
        );

        binde = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
        windowrulev2 = [
          "float, class:(virt-manager)"
          "stayfocused, class:(virt-manager)"
          "tile, class:(virt-viewer)" # Ensures the actual VM console behaves
        ];
      };
  

    };

    # Program enables
    programs.kitty.enable = true;
    programs.waybar.enable = true;
  };
}