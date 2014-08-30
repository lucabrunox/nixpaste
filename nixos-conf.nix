{ config, pkgs, ... }:

let
  nixpaste = import /home/nixpaste/nixpaste {
    inherit pkgs;
    storageDir = "/home/nixpaste/storage";
  };
in

{
  
  systemd.services.nixpaste = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${nixpaste}/bin/nixpaste";
  };

  users.extraUsers.nixpaste = {
    name = "nixpaste";
    group = "users";
    uid = 2001;
    createHome = true;
    home = "/home/nixpaste";
    shell = "/run/current-system/sw/bin/bash";
  };

}  
