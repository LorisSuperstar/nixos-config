{ config, pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    # package = pkgs.kdePackages.sddm; # <--- DELETE OR COMMENT THIS LINE
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs.kdePackages; [ 
      qt5compat 
      qtdeclarative 
      qtsvg 
      qtmultimedia 
    ];
    settings = {
      General.InputMethod = "";
    };
  };

  programs.hyprland.enable = true;

  # SDDM custom wallpaper override
  environment.etc."sddm.conf.d/theme.conf.user".text = ''
    [General]
    Background=${/home/loris/nixos-config/assets/wallpaper.png}
  '';

  # Mouse quirk fix
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Roccat Kain 120 Aimo CPS Fix]
    MatchName=ROCCAT ROCCAT Kain 120 Aimo*
    ModelBouncingKeys=1
  '';
}
