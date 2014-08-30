with (import <nixpkgs> {});
with python2Packages;

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
    
    buildInputs = [ python gevent makeWrapper ];
    
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
