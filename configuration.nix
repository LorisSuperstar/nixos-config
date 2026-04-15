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
  boot.kernelPackages = pkgs.linuxPackages;
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
    extraGroups = [ "wheel" "networkmanager" "video" "libvirtd"];
  };

  # System Software
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    gamescope mangohud git vim steam-run hyprpaper sddm-astronaut protontricks wineWowPackages.stagingFull
    (virt-manager.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/virt-manager \
        --set GDK_BACKEND x11
    '';
  }))
  vlc
  dunst
  libnotify
  swww
  flameshot
  fastfetch
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Optional
    dedicatedServer.openFirewall = true; # Optional
    gamescopeSession.enable = true; # Adds Gamescope integration
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

  networking.nameservers = [ "194.127.2.2" "adblock.dns.mullvad.net" ];
  services.dbus.enable = true;

  services.desktopManager.plasma6.enable = true;

programs.java = {
  enable = true;
  package = pkgs.jdk25; # or your specific version
};

# Ensure you have this enabled
security.pki.certificateFiles = [ ]; # This is usually empty by default but triggers the symlinking
}