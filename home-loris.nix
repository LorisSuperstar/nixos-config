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

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors"; 
      size = 32;
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
      bitwarden-desktop
      qbittorrent

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
        
        # Add these to your env list to tell GTK and Hyprland exactly what to do
        env = [
          "XCURSOR_THEME,catppuccin-mocha-mauve-cursors"
          "XCURSOR_SIZE,32"
          "HYPRCURSOR_THEME,catppuccin-mocha-mauve-cursors"
          "HYPRCURSOR_SIZE,32"
          "WLR_DRM_NO_ATOMIC,1"
        ];

        # Add this to your exec-once to force the cursor to change on login
        "exec-once" = [
          "hyprctl setcursor catppuccin-mocha-mauve-cursors 32"
          "opensnitch-ui --background"
          "waybar"
          "swww-daemon"
          "swww img /home/loris/Pictures/wallpaper.png"
          "kitty --hold -e fastfetch"
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
          "col.active_border" = "rgba(6e43a6ee)";
          "col.inactive_border" = "rgba(1e1a29aa)";
          layout = "dwindle";
        };

        decoration = {
          active_opacity = 1.0;
          inactive_opacity = 0.95;
          shadow.enabled = true;
          blur.enabled = true;
        };

        "$mainMod" = "SUPER";
        
        bind = [
          "$mainMod, Q, exec, kitty"
          "$mainMod, D, exec, fuzzel"
          "$mainMod, C, killactive"
          "$mainMod, F, fullscreen, 0"
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