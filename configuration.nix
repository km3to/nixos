{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # --- Bootloader ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Networking ---
  networking.hostName = "laptop";  
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Sofia";
  services.timesyncd.enable = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Graphics Configuration
  hardware.graphics.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "km3to";
        wayland = true;
      };
    };
  };

  security.pam.services.swaylock = {};

  programs.dconf.enable = true;

  # Enable sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.km3to = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  };

  # Swapfile
  #swapDevices = [ { device = "/swapfile"; size = "__SWAP_SIZE_PLACEHOLDER__"; } ];
  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nano
    git
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}

