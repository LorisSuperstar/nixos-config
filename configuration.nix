{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
    ./desktop.nix      # Pulls in SDDM/Hyprland
    ./home-loris.nix   # Pulls in your user apps/configs
  ];

  # Boot & Hardware
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = { enable = true; enable32Bit = true; };

  # Localization
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true; 
    keyMap = "sg"; 
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    packages = with pkgs; [ terminus_font ];
  };
  services.xserver.xkb = { layout = "ch"; variant = ""; };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Users
  users.users.loris = {
    isNormalUser = true;
    # All groups must be in this one list
    extraGroups = [ "wheel" "networkmanager" "video" "libvirtd" "libvirtd"];
  };

  # System Software
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git vim steam-run hyprpaper sddm-astronaut bibata-cursors protontricks lutris bottles wineWowPackages.stagingFull winetricks pkgs.bottles
    (virt-manager.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/virt-manager \
        --set GDK_BACKEND x11
    '';
  }))
  ];
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Optional
  dedicatedServer.openFirewall = true; # Optional
};
  programs.gamemode.enable = true;

  # Fonts & Maintenance
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono nerd-fonts.fira-code
    noto-fonts noto-fonts-color-emoji
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  system.stateVersion = "25.11";

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}