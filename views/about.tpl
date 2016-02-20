<!DOCTYPE html>

<html lang="en">
 
 <head>
  <title>Nix Pastebin</title>
  
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
  
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  
  <link rel="stylesheet" href="css/bootstrap.min.css" />
  
  <link rel="stylesheet" href="css/bootstrap-responsive.min.css" />
  
  <link rel="stylesheet" href="css/nixos-site.css" type="text/css" />

  <link rel="stylesheet" href="css/nixpaste-site.css" type="text/css" />
  
  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" />
  
 </head>
 
 <body>
  
  <div class="navbar navbar-fixed-top">
   <div class="navbar-inner">
	<div class="container">
	 <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
	  <span class="icon-bar"></span>
	  <span class="icon-bar"></span>
	  <span class="icon-bar"></span>
	 </button>
	 <a class="brand" href="{{URL}}">
	  <img src="img/nix-wiki.png" alt="NixOS" class="logo" />
	 </a>
	 <a class="brand" href="{{URL}}">NixPaste</a>
	 <div class="nav-collapse collapse">
	  <ul class="nav pull-left">
	   <li><a href="./about.html">About</a></li>
	   <li><a href="http://nixos.org">NixOS</a></li>
	  </ul>
	  <ul class="nav pull-right">
	   <li><a href="https://github.com/lethalman/nixpaste"><i class="fa fa-github"></i></a></li>
	  </ul>
	 </div>
	</div>
   </div>
  </div>

  <div class="container">
   <div class="row" style="height: 50px"></div>
   <div class="row">
	<div class="about jumbotron span12">

	 <p class="lead">This site is a sample deployment of <a href="https://github.com/lethalman/nixpaste">nixpaste</a>, a pastebin like <a href="http://sprunge.us/">sprunge.us</a> but made for the Nix community.
	 </p>

	 <p class="lead">The deployment and the auto generation of this site has been made with <a href="http://nixos.org/nix">Nix</a>.
	  </p>

	 <p class="lead">There's a limit to the number of pastes, and to the total used disk space. Therefore, older entries expire automatically. There is no public browsing of the pastes.
	 </p>

	 <p class="lead">Find more about the <a href="http://nixos.org/">NixOS project</a>.</p>

	 <h2>How does it work</h2>

	 <p class="lead">Pastes are numerated incrementally, starting from 1. To get the URL of a paste, the number is hashed with a truncated HMAC plus a site-specific salt.</p>

	 <p class="lead">Pastes are stored as files, within a simple directory hierarchy based on the hash.</p>

	 <p class="lead">Before saving a new paste, older pastes are evicted until physical limits (number of pastes and disk space) are satisfied.</p>

	 <p class="lead">Information about current space consumption, number of pastes, oldest and newest paste number, are saved in a simple JSON file.</p>
	</div>
	 
   </div>
  </div>
    
 </body>
</html>