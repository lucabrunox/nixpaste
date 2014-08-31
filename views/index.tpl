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
 
 <body class="fill">
  
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
	   <li><a href="about">About</a></li>
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
  
  <div class="container fill">
   <div class="as-table">
   <div class="row" style="height: 50px"></div>
   <div class="row">
	<div class="jumbotron span12">
	 
	 <button type="button" class="btn btn-link" data-toggle="collapse" data-target="#cmdpaste"><i class="fa fa-keyboard-o"></i> Paste from the command line</button>

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

   <form role="form" method="POST" class="as-table-row" action="{{ URL }}">
	<div class="fill as-table">
	<div id="acecontainer" class="as-table-row" style="display: none;">
	 <div class="as-table">
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

	 <div class="row as-table-row">
	  <div class="span12 fill nomargin">
	   <div id="editor" class="fill">{{ pasteText }}</div>
	  </div>
	 </div>
	 </div> <!-- as-table -->

	 <input type="hidden" id="ace-form" />
	  
	</div>
	  
	<script src="js/nixpaste.js" type="text/javascript" charset="utf-8"></script>

	<noscript class="as-table-row">
	 <div class="as-table">
	 <div class="row">
	  % setdefault("pasteHash", None)
	  % if pasteHash:
	  <div class="span2">
	   <a type="button" class="btn" href="{{ URL }}/raw/{{ pasteHash }}">View raw</a>
	  </div>
	  % end
	 </div>
	 
	 <div class="row fill as-table-row">
	  <div class="span12 fill nomargin">
	   <textarea name="browser_text" class="form-control span12 fill" placeholder="Paste here">{{ pasteText }}</textarea>
	  </div>
	 </div>
	 </div> <!-- as-table -->
	</noscript>

	<div id="pastesubmit" class="row">
	 <div class="span1">
	  <button type="submit" class="btn btn-large btn-info">Paste</button>
	 </div>
	</div>
	</div><!-- as-table -->

   </form>
   
  </div>
  
 </body>
</html>