(function(){
	$("#acecontainer").show();
	
	var editor = ace.edit("editor");
	editor.setTheme("ace/theme/github");
	editor.getSession().setMode("ace/mode/nix");
	editor.renderer.setScrollMargin(10, 10, 10, 10);
	editor.renderer.setPadding(10, 10, 10, 10);
	editor.renderer.setShowGutter(false);
	editor.setShowPrintMargin(false);
	editor.setFontSize(18);
	editor.setHighlightActiveLine(false);
	
	var modelist = ace.require("ace/ext/modelist");
	var optionsStr = "";
	for (var i in modelist.modes) {
		var mode = modelist.modes[i];
		var selected = mode.name == "nix" ? 'selected="selected"' : "";
		optionsStr += "<option value='"+mode.mode+"' "+selected+">"+mode.caption+"</option>";
	}
	$(".selectpicker").html(optionsStr);
	
	editor.focus();

	$(window).on('load', function () {
		$('.selectpicker').selectpicker();
    });
})();