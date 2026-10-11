{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./hardware-configuration.nix
    ./desktop.nix      # SDDM/Hyprland
    ./home-loris.nix   # User apps/configs
  ];

  # Flatpak & Desktop Services
  services.flatpak.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.dbus.enable = true;

  # Boot & Hardware
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Localization & Console
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
  services.xserver.xkb = {
    layout = "ch";
    variant = "";
  };

  # Audio (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User Accounts
  users.users.loris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "libvirtd" ];
  };

  # Virtualization
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # System Software & Unfree Packages
  nixpkgs.config.allowUnfree = true;

  # Systemd service to run LiteLLM proxy listening on port 4000
  systemd.services.litellm = {
    description = "LiteLLM Proxy Server";
    after = [ "network.target" "ollama.service" ];
    wantedBy = [ "multi-user.target" ];
    
    # Environment variables if you add other keys later
    # environment = { OPENAI_API_KEY = "sk-..."; };

    serviceConfig = {
      ExecStart = "${pkgs.litellm}/bin/litellm --model ollama/llama3.2:1b --port 4000";
      Restart = "always";
      User = "loris";
    };
  };

  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk
    losslesscut-bin
    gamescope
    mangohud
    git
    vim
    steam-run
    hyprpaper
    sddm-astronaut
    protontricks
    wineWowPackages.stagingFull
    zenity
    wget
    xdg-desktop-portal-gtk
    vlc
    dunst
    libnotify
    swww
    fastfetch
    grimblast
    wowup-cf
    nodejs_20
    steamtinkerlaunch
    python312
    litellm
    python3
    python3Packages.pipx
  ];

  # Gaming & Performance
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      steamtinkerlaunch
    ];
  };
  programs.gamemode.enable = true;
  networking.firewall.checkReversePath = false;

  # File Manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };

  # Java Environment
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-color-emoji
  ];

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Home Manager Setup
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  system.stateVersion = "25.11";
}