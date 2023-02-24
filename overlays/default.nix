{ inputs, ... }: {
  # drag in any custom packages in the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # any overlay you want to add. change versions, add patches, etc.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
