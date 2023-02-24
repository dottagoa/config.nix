# custom packages, defined similarly to those in nixpkgs.
# you can build them with 'nix build .#example'.

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  # example = pkgs.callPackage ./example { };
}
