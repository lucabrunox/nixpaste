with (import <nixpkgs> {});
with pythonPackages;

let

  pygments2 = buildPythonPackage rec {
    name = "Pygments-2.0-git";

    src = fetchurl {
      url = "https://bitbucket.org/birkenfeld/pygments-main/get/9f2e523c90ea6368b8388fe7f02f9e5f59628a68.tar.gz";
      sha256 = "1zgisv8cd7nqqfc2yaz2cc0imqp2nnmva10hd3nz19lsq9qwp8f1";
    };

    meta = pygments.meta;
  };

  webapp2 = buildPythonPackage rec {
    name = "webapp2-2.5.1";
    
    propagatedBuildInputs = [ webob ];

    src = fetchurl {
      url = "https://webapp-improved.googlecode.com/files/${name}.zip";
      sha256 = "04yj2hz4jx3lllgwa9gsk4whbqgpzq56pxr2733hxi5aq0dgp662";
    };

  };

in

{ url ? "http://localhost:8080", postField ? "text",
  bindAddress ? "", bindPort ? 8080,
  static ? ./static, views ? ./views,
  storageDir ? "/tmp/nixpaste", maxBytes ? 1000000, maxFiles ? 1000,
  hashSalt ? "somesalt", hashLength ? 6,
  extraTemplateVars ? {}
}:

assert hashSalt != null;
assert hashLength > 4;

let

  opts = { inherit url postField bindAddress bindPort static views storageDir maxBytes maxFiles hashSalt hashLength; };
  
  configjson = pkgs.writeText "nixpaste-config" ''{
    "STATIC": "${static}",
    "VIEWS": "${views}",
    "URL": "${url}",
    "POST_FIELD": "${postField}",
    "BIND": "${bindAddress}",
    "PORT": ${builtins.toString 8080},
    "DIR": "${storageDir}",
    "MAX_BYTES": ${builtins.toString maxBytes},
    "MAX_FILES": ${builtins.toString 3},
    "SALT": "${hashSalt}",
    "LENGTH": ${builtins.toString hashLength}
  }'';
  
in
  
  stdenv.mkDerivation {
    name = "nixpaste";
    
    buildInputs = [ python2 pygments2 webapp2 makeWrapper ];
    
    buildCommand = ''
      mkdir -p $out/bin
      mkdir -p $out/python-lib
      cp -pdv ${./nixpaste.py} $out/bin/nixpaste
      ln -s ${./bottle.py} $out/python-lib/bottle.py
      wrapProgram $out/bin/nixpaste \
        --prefix PYTHONPATH : "$out/python-lib:$PYTHONPATH" \
        --set NIXPASTE_CONFIG ${configjson}
      patchShebangs $out
    '';
  }
