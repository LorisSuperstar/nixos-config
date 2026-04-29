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
  # --- VM Monitor (Virtual-1) ---
  layer = "top";
  position = "top";
  output = "Virtual-1";
  height = 30;
  spacing = 4;

  modules-left = [ "hyprland/workspaces" ];
  modules-center = [ "clock" ];
  modules-right = [ "tray" "custom/processes" "custom/fuzzel" ];

  "hyprland/workspaces" = {
    all-outputs = true;
    format = "{name}";
  };

  "clock" = {
    format = "{:%H:%M}";
  };

  "tray" = {
    icon-size = 18;
    spacing = 10;
  };

  "custom/processes" = {
    format = "";
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
          background: transparent; /* Makes the bar float naturally */
          color: #cdd6f4;
      }

      /* Each module "pill" */
      #workspaces, #clock, #custom-fuzzel, #custom-processes, #tray {
          background: #1e1a29; /* Very dark midnight purple */
          padding: 0px 10px;
          margin: 4px 4px;
          border-radius: 8px;
          border: 1px solid #312b45; /* Subtle dark purple border */
      }

      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: #a5adcb;
          border-bottom: 2px solid transparent;
          transition: all 0.3s ease;
      }

      /* The Active Workspace - Matching your border color! */
      #workspaces button.focused, #workspaces button.active {
          background: #3c2a52; /* Muted deep purple */
          color: #cba6f7;      /* Bright purple text */
          border-bottom: 2px solid #6e43a6; /* Your static purple border color */
      }

      #workspaces button:hover {
          background: #2a2438;
          color: #cba6f7;
      }

      /* Module Specific Colors */
      #clock {
          color: #cba6f7;
          font-weight: bold;
      }

      #custom-processes { 
          color: #6e43a6; 
      }

      #custom-fuzzel { 
          color: #6e43a6; /* Your main purple color */
      }

      #tray {
          padding: 0 10px;
      }
    '';
  };
}