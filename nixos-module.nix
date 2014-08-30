{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.services.nixpaste;
  nixpaste = cfg.expr ({ inherit pkgs; } // cfg.config);
in

{

  options = {
    services.nixpaste = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };

      expr = mkOption {
      };

      config = mkOption {
        default = {};
        type = types.attrs;
      };

      user = mkOption {
        default = "nixpaste";
        type = types.str;
      };

      uid = mkOption {
        default = 2001;
        type = types.int;
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.nixpaste = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.User = cfg.user;
      serviceConfig.ExecStart = "${nixpaste}/bin/nixpaste";
    };

    users.extraUsers = optional (cfg.user == "nixpaste") {
      name = cfg.user;
      group = "users";
      uid = cfg.uid;
      createHome = true;
      home = "/home/nixpaste";
      shell = "/run/current-system/sw/bin/bash";
    };
  };

}  
