with (import <nixpkgs> {});
with python2Packages;

{ url ? "http://localhost:8080", postField ? "text",
  bindAddress ? "", bindPort ? 8080,
  static ? ./static, views ? ./views, unicornFlags ? "-b 0.0.0.0:8080 -t 10",
  storageDir ? "/tmp/nixpaste", maxBytes ? 100000000, maxFiles ? 1000,
  hashSalt ? "somesalt", hashLength ? 6
}:

assert hashSalt != null;
assert hashLength > 4;

let

  configjson = pkgs.writeText "nixpaste-config" ''{
    "STATIC": "${static}",
    "VIEWS": "${views}",
    "URL": "${url}",
    "POST_FIELD": "${postField}",
    "BIND": "${bindAddress}",
    "PORT": ${builtins.toString bindPort},
    "DIR": "${storageDir}",
    "MAX_BYTES": ${builtins.toString maxBytes},
    "MAX_FILES": ${builtins.toString maxFiles},
    "SALT": "${hashSalt}",
    "LENGTH": ${builtins.toString hashLength}
  }'';
  
in
  
  stdenv.mkDerivation {
    name = "nixpaste";
    
    buildInputs = [ python gunicorn gevent makeWrapper ];

    inherit (python) sitePackages;
    
    buildCommand = ''
      mkdir -p $out/bin
      mkdir -p $out/$sitePackages/nixpaste
      
      cp -pdv ${./nixpaste} $out/bin/nixpaste
      cp -v ${./nixpaste.py} $out/$sitePackages/nixpaste/__init__.py
      cp -v ${./bottle.py} $out/$sitePackages/nixpaste/bottle.py
      
      wrapProgram $out/bin/nixpaste \
        --prefix PYTHONPATH : "$out/$sitePackages:$PYTHONPATH" \
        --set NIXPASTE_CONFIG ${configjson} \
        --prefix PATH : $PATH
      patchShebangs $out
    '';
  }
