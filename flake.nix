{
  description = "Customized nixpkgs apps";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: (
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [bun_overlay];
      };

      # using baseline bun because I have very old CPU
      bun_overlay = self: super: {
        bun = super.bun.overrideAttrs (prev: rec {
          name = "bun-baseline-${version}";
          version = "1.0.14";
          src = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
            hash = "sha256-7vSYdYzhXdmw+s+HMPGOjVogIgnswu1jWdD3uQsPem8=";
          };
        });
      };

      bun = pkgs.bun;
    in {
      packages.x86_64-linux = {
        inherit bun;
        default = bun;
      };
      formatter.${system} = pkgs.alejandra;
    }
  );
}
