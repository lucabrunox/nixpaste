nixpaste
========

Pastebin powered by Python and deployed by Nix:

```
$ cd /home/nixpaste
$ git clone https://github.com/lethalman/nixpaste.git
$ nix-build
$ result/bin/nixpaste
```

Deployment on NixOS:

```
{
  imports = [
    /home/nixpaste/nixpaste/nixos-module.nix
  ];
  
  services.nixpaste = {
    enable = true;
    expr = import /home/nixpaste/nixpaste;
    config = {
      storageDir = "/home/nixpaste/storage";
      url = "http://nixpaste.noip.me";
    };
  };
}
```

For development:

```
$ nix-shell dev.nix
```