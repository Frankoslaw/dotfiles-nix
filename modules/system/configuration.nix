{ config, pkgs, inputs, ... }:

{
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    virtualisation.libvirtd.enable = true;
    virtualisation.docker.enable = true;
    virtualisation.podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
    };

    programs.dconf.enable = true;
    programs.zsh.enable = true;

    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    # Install fonts
    fonts = {
        fonts = with pkgs; [
            jetbrains-mono
            roboto
            openmoji-color
            (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];
    };

    # Bootloader.
    boot.loader = {
        grub = {
            enable = true;
            version = 2;
            device = "nodev";
            useOSProber = true;
            efiSupport = true;
        };

        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
        };
    };
    
    # Fix time( dual boot issue )
    time.hardwareClockInLocalTime = true;

    # Enable networking
    networking.networkmanager.enable = true;

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

    # Set environment variables
    environment.variables = rec {
        NIXOS_CONFIG = "$HOME/.config/nixos/configuration.nix";
        NIXOS_CONFIG_DIR = "$HOME/.config/nixos/";
        XDG_DATA_HOME = "$HOME/.local/share";
    };

    # Enable sound with pipewire.
    sound.enable = true;
    services.pipewire.alsa.support32Bit = true;

    hardware.pulseaudio.enable = true;
    hardware.opengl.driSupport = true;
    hardware.opengl.driSupport32Bit = true;

    security.rtkit.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.frankoslaw = {
        isNormalUser = true;
        description = "Franciszek Łopuszański";
        extraGroups = [ "networkmanager" "input" "wheel" "qemu-libvirtd" "libvirtd" "docker" ];
        shell = pkgs.zsh;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Nix settings, auto cleanup and enable flakes
    nix = {
        settings.auto-optimise-store = true;
        settings.allowed-users = [ "frankoslaw" ];
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
        vim wget firefox
        gnome.gedit neofetch
        git acpi tlp nano
        doas cachix
    ];

    security = {
        sudo.enable = false;
        doas = {
            enable = true;
            extraRules = [{
                users = [ "frankoslaw" ];
                keepEnv = true;
                persist = true;
            }];
        };

        # Extra security
        protectKernelImage = true;
    };

    # Do not touch
    system.stateVersion = "22.11";

}
