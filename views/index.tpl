<!DOCTYPE html>

<html lang="en">
 
 <head>
  <title>Nix Pastebin</title>
  
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
   
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <link rel="stylesheet" href="css/bootstrap.min.css" />

  <link rel="stylesheet" href="css/bootstrap-slider.css" />
  
  <link rel="stylesheet" href="css/nixos-site.css" type="text/css" />

  <link rel="stylesheet" href="css/nixpaste-site.css" type="text/css" />
  
  <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" />

  <link rel="stylesheet" href="css/bootstrap-select.min.css" />

  <script src="js/jquery.min.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <script src="http://cdn.jsdelivr.net/ace/1.1.5/min/ace.js" type="text/javascript" charset="utf-8"></script>
  <script src="http://cdn.jsdelivr.net/ace/1.1.5/min/ext-modelist.js" type="text/javascript" charset="utf-8"></script>
  <script src="js/bootstrap-select.min.js" type="text/javascript" charset="utf-8"></script>
  <script src="js/bootstrap-slider.js" type="text/javascript" charset="utf-8"></script>
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
	 <a class="brand" href="index.html">
	  <img src="img/nix-wiki.png" alt="NixOS" class="logo" />
	 </a>
	 <a class="brand" href="index.html">NixPaste</a>
	 <div class="nav-collapse collapse">
	  <ul class="nav pull-left">
	   <li><a href="about.html">About</a></li>
	   <li><a href="http://nixos.org">NixOS</a></li>
	  </ul>
	  <ul class="nav pull-right">
	   <li><a href="https://github.com/lethalman/nixpaste"><i class="fa fa-github"></i></a></li>
	  </ul>
	 </div>
	</div>
   </div>
  </div>

  % setdefault("pasteText", "")
  % setdefault("pasteSyntax", "nix")
  
  <div class="container">
   <div class="row">
	<div class="jumbotron span12">
	 
	 <button type="button" class="btn btn-medium btn-info" data-toggle="collapse" data-target="#cmdpaste">Paste from the command line</button>

	 <div id="cmdpaste" class="collapse out">
	  <pre>$ &lt;command&gt; | curl -F '{{POST_FIELD}}=&lt;-' {{URL}}</pre>
	 
	  <pre>$ alias nixpaste="curl -F '{{POST_FIELD}}=&lt;-' {{URL}}"
$ command | nixpaste
$ nixpaste < ./myexpr.nix</pre>
	 </div>

	 <noscript>
	  <div>
	   <pre>$ &lt;command&gt; | curl -F '{{POST_FIELD}}=&lt;-' {{URL}}</pre>
	 
	   <pre>$ alias nixpaste="curl -F '{{POST_FIELD}}=&lt;-' {{URL}}"
$ command | nixpaste
$ nixpaste < ./myexpr.nix</pre>
	  </div>
	 </noscript>

	</div>
   </div>
  </div>
  
  <div class="container">

   <form role="form" method="POST" action="{{ URL }}">

	<div id="acecontainer" style="display: none;">
	 
	 <div class="row">
	  % setdefault("pasteHash", None)
	  % if pasteHash:
	  <div class="span2">
	   <a type="button" class="btn" href="{{ URL }}/raw/{{ pasteHash }}">View raw</a>
	  </div>
	  <div class="offset7 span1">
	   <div id="fontsize" class="span1"></div>
	  </div>
	  % else:
	  <div class="offset9 span1">
	   <div id="fontsize" class="span1"></div>
	  </div>
	  % end
	  
	  <div class="span2">
	   <select name="syntax" data-live-search="true" data-syntax="{{ pasteSyntax }}" class="selectpicker span2"></select>
	  </div>
	 </div>

	 <div class="row">
	  <div class="span12">
	   <div id="editor">{{ pasteText }}</div>
	  </div>
	 </div>

	 <input type="hidden" id="ace-form" />
	  
	</div>
	  
	<script src="js/nixpaste.js" type="text/javascript" charset="utf-8"></script>

	<noscript>
	 <div class="row">
	  % setdefault("pasteHash", None)
	  % if pasteHash:
	  <div class="span2">
	   <a type="button" class="btn" href="{{ URL }}/raw/{{ pasteHash }}">View raw</a>
	  </div>
	  % end
	 </div>
	 
	 <div class="row">
	  <div class="span12">
	   <textarea name="browser_text" class="form-control span12" placeholder="Paste here">{{ pasteText }}</textarea>
	  </div>
	 </div>
	</noscript>

	<div class="row">
	 <div class="span1">
	  <button type="submit" class="btn btn-large">Paste</button>
	 </div>
	</div>

   </form>
   
  </div>
  
 </body>
</html>