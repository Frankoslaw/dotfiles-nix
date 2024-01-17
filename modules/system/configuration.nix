{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    # waydroid.enable = true;
    docker.enable = false;
    lxd.enable = false;
  };

  programs.dconf.enable = true;
  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.wireshark.enable = true;

  # Install fonts
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
  };

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    # grub = {
    #   enable = true;
    #   useOSProber = true;
    #   device = "nodev";
    #   efiSupport = true;
    # };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  # Fix time( dual boot issue )
  time.hardwareClockInLocalTime = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
      # for NFSv3; view with `rpcinfo -p`
    allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 1764 ];
    allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 1764 ];
    allowedTCPPortRanges = [
      # KDE Connect
      { from = 1714; to = 1764; }
    ];
    allowedUDPPortRanges = [
      # KDE Connect
      { from = 1714; to = 1764; }
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  services.printing.drivers = with pkgs; [ 
    hplip
    hplipWithPlugin 
  ];

  services.nfs.server.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };
  };

  # Set environment variables
  environment.variables = rec {
    NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
    NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
    XDG_DATA_HOME = "$HOME/.local/share";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.support32Bit = true;
  };

  hardware.pulseaudio.enable = true;
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.frankoslaw = {
    isNormalUser = true;
    description = "Franciszek Łopuszański";
    extraGroups = ["networkmanager" "input" "wheel" "qemu-libvirtd" "libvirtd" "docker" "podman" "wireshark"];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix settings, auto cleanup and enable flakes
  nix = {
    settings.auto-optimise-store = true;
    settings.allowed-users = ["frankoslaw"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Nix software center
    inputs.nix-software-center.packages.${system}.nix-software-center

    wl-clipboard
    vim
    wget
    firefox
    gnome.gedit
    neofetch
    git
    acpi
    tlp
    nano
    doas
    cachix
    wireshark
  ];

  security = {
    sudo.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["frankoslaw"];
          keepEnv = true;
          persist = true;
        }
      ];
    };

    # Extra security
    protectKernelImage = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
    "electron-25.9.0"
  ];

  # Do not touch
  system.stateVersion = "23.11";
}
