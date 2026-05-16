{
  description = "NixOS Proxmox cloud-init template (qcow2)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators }: {
    packages.x86_64-linux.proxmox-qcow = nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      format = "qcow";
      modules = [ ./configuration.nix ];
    };
  };
}
