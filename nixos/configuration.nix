{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # have a module from another flake? import it here!
    # inputs.hardware.nixosModules.common-ssd

    # or if you have a .nix in another kingdom:
    ./users.nix

    # let's not forget our hardware config
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      # overlays from other flakes can sometimes exist
      # they can also be inline if you feel like it.
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true; # i'm not cheap!
    };
  };

  nix = {
    # make each flake behave like a registry so nix3 commands stay consistent with my flake[y hair]
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # also add these inputs to the legacy channels so they don't whine like a baby wanting CANDY
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # we want the flakes to work, right? RIGHT??
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # FIXME: put the rest of your DAMN CONFIG here.

  # <-------- MY CONFIG --------> #

  time.timeZone = "America/New_York";
  
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.libinput.enable = true;

  # <------ END MY CONFIG ------> #

  networking.hostName = "apollyon";
  boot.loader.systemd-boot.enable = true;

  users.users = {
    zyx = {
      # if this password is set, skip setting a root password with '--no-root-passwd' when using nixos-install
      initialPassword = "changeThis$tupidP4sswdNAO!";
      isNormalUser = true;
      
      openssh.authorizedKeys.keys = [
        # TODO: i lost my keys outside my car
      ];

      # TODO: add yourself to other groups if using docker or any of that stuff
      extraGroups = [ "wheel" ];
    };
  };

  # WHERE? IS? MY? SSH, SERVER?
  # only use if you have no head
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no"; # i ground up all the trees in a 50 kilometre radius
      PasswordAuthentication = false;
    };
  };

  # BRIAN, WHAT DID I TELL YOU ABOUT ALTERING THE PAST?!
  # read this... if you dare! (to change this setting)
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
