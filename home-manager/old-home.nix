{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.zyx = let
      flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
      hyprland = (import flake-compat {
        src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
      }).defaultNix;
    in {
      imports = [
        hyprland.homeManagerModules.default
      ];

      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
	trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };

      home = {
	useranem = "zyx";
	homeDirectory = "/home/zyx";

        stateVersion = "22.11";
	packages = with pkgs; [
	  hyprland
	  wayland
	];

	sessionVariables = {
	  EDITOR = "nvim";
	};
      };

      wayland.windowManager.hyprland.enable = true;

      programs.home-manager.enable = true;
      programs.bash.enable = true;
      
      programs.neovim = {
        enable = true;
        extraConfig = ''
          set number relativenumber
        '';
        viAlias = true;
        vimAlias = true;
      };
    };
  };
}
