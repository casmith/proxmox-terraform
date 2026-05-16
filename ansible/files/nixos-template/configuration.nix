{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    # virtio drivers in initrd, qemu-ga-friendly defaults
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  services.qemuGuest.enable = true;

  virtualisation.docker.enable = true;

  # Proxmox attaches cloud-init config as a NoCloud ISO on ide2.
  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings.datasource_list = [ "NoCloud" "ConfigDrive" ];
  };

  # Required so cloud-init can create the VM user + drop SSH keys at first boot.
  users.mutableUsers = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Auto-grow root partition on first boot to whatever size Terraform provisioned.
  boot.growPartition = true;

  # Match Proxmox's `--serial0 socket --vga serial0` so the console works.
  boot.kernelParams = [ "console=ttyS0,115200n8" "console=tty0" ];
  boot.loader.grub.extraConfig = ''
    serial --unit=0 --speed=115200
    terminal_input serial
    terminal_output serial
  '';

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    curl
    wget
    docker-compose # provides `docker compose` v2 as a Docker CLI plugin
  ];

  networking.hostName = lib.mkDefault "nixos";

  system.stateVersion = "25.11";
}
