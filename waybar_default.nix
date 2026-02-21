{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    
    settings = [
      {
        # --- Monitor 1 (DP-1) ---
        layer = "top";
        position = "top";
        output = "DP-1";
        height = 30;
        spacing = 4;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        # Added "tray" here
        modules-right = [ "tray" "custom/processes" "custom/fuzzel" ];

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{name}";
        };

        "tray" = {
          icon-size = 18;
          spacing = 10;
        };

        "clock" = { 
          format = "{:%H:%M}"; 
        };

        "custom/processes" = {
          format = "";
          tooltip = true;
          tooltip-format = "View Running Processes";
          on-click = "${pkgs.foot}/bin/foot -e ${pkgs.btop}/bin/btop";
        };

        "custom/fuzzel" = {
          format = "";
          on-click = "${pkgs.fuzzel}/bin/fuzzel";
        };
      }
      {
        # --- Monitor 2 (HDMI-A-2) ---
        layer = "top";
        position = "top";
        output = "HDMI-A-2";
        height = 30;
        spacing = 4;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        # No tray on second monitor (usually only one tray allowed)
        modules-right = [ "custom/processes" "custom/fuzzel" ];

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{name}";
        };

        "clock" = { 
          format = "{:%H:%M}"; 
        };

        "custom/processes" = {
          format = "";
          tooltip = true;
          tooltip-format = "System Monitor";
          on-click = "${pkgs.foot}/bin/foot --title btop-float -e ${pkgs.btop}/bin/btop";
        };

        "custom/fuzzel" = {
          format = "";
          on-click = "${pkgs.fuzzel}/bin/fuzzel";
        };
      }
    ];

    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background: rgba(21, 18, 27, 0); 
          color: #cdd6f4;
      }

      #workspaces, #clock, #custom-fuzzel, #custom-processes, #tray {
          background: #1e1e2e;
          padding: 0px 10px;
          margin: 4px 4px;
          border-radius: 10px;
          border: 1px solid #313244;
      }

      #tray {
          padding-right: 8px;
          padding-left: 8px;
      }

      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: #cdd6f4;
          border-bottom: 3px solid transparent;
      }

      #workspaces button.active {
          background: #45475a;
          color: #f5c2e7;
          border-bottom: 3px solid #f5c2e7;
      }

      #custom-processes { color: #89b4fa; }
      #custom-fuzzel { color: #f5c2e7; }
    '';
  };
}