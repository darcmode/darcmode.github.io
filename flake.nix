{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let overlays = [ ];
            pkgs = import nixpkgs {
              inherit system overlays;
            };
            lua = pkgs.lua5_4.withPackages(ps: with ps; [
              luacheck
              luarocks
            ]);
        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs = [
              gnumake
              pandoc
              # python
              python312
              pyright
              # lua
              lua
              lua-language-server
              # openssl is required for lua-openapi
              openssl
            ];

            shellHook = ''
              export GH_USER="$USER"
            '';
          };
        }
      );
}
  
