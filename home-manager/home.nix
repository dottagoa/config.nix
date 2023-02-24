{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # import stuff here if you want to use home-manager modules from other flakes
    # or you want to split your config into cute-n-tiny pieces

    inputs.nix-colors.homeManagerModule
    # ./nvim.nix
  ];

  # configure silly nix packages
  nixpkgs = {
    overlays = [
      # overlays from other flakes, if any. you can also define inline overlays:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true; # spare me, GNU-san
      # workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };
  
  # it's me!
  home = {
    username = "zyx";
    homeDirectory = "/home/zyx";

    # read this wiki page if you EVER need to even CONSIDER changing this:
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    # NEVER CHANGE THIS WITHOUT READING CHANGELOGS! you know better >:(
    stateVersion = "22.11";

    packages = with pkgs; [
      nodejs-19_x
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    # home manager needs to actually be on to use it
    # don't EVER disable this or i will be sad :(
    home-manager.enable = true;

    git.enable = true;

    neovim = {
      enable = true;
      extraConfig = ''
        set number relativenumber
      '';
      viAlias = true;
      vimAlias = true;
    };
  };

  # reload system units smoothly when changing configs, rather than immaculately combusting
  systemd.user.startServices = "sd-switch";
}
