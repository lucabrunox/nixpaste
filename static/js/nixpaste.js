(function(){
	$("#acecontainer").show();
	
	var editor = ace.edit("editor");
	editor.setTheme("ace/theme/github");
	editor.getSession().setMode("ace/mode/nix");
	editor.renderer.setScrollMargin(10, 10, 10, 10);
	editor.renderer.setPadding(10, 10, 10, 10);
	editor.renderer.setShowGutter(false);
	editor.setShowPrintMargin(false);
	editor.setFontSize(16);
	editor.setHighlightActiveLine(false);
	
	var modelist = ace.require("ace/ext/modelist");
	var optionsStr =
	'<option value="ace/mode/nix" selected="selected">Nix</option>'+
	'<option value="ace/mode/sh">Shell</option>'+
	'<option value="ace/mode/perl">Perl</option>'+
	'<option data-divider="true"></option>';
	
	for (var i in modelist.modes) {
		var mode = modelist.modes[i];
		if (mode.name == "nix" || mode.name == "sh" || mode.name == "perl") {
			continue;
		}
		optionsStr += "<option value='"+mode.mode+"'>"+mode.caption+"</option>";
	}
	$(".selectpicker").html(optionsStr).change(function(ev) {
			editor.getSession().setMode(ev.currentTarget.value);
	});
	$("#fontsize").slider({
			min: 10,
			max: 24,
			value: 16,
			formater: function(val) { return "Font size: "+val; }
	}).on ('slide', function(ev) {
			editor.setFontSize(ev.value);
	});
	
	editor.focus();

	$(window).on('load', function () {
		$('.selectpicker').selectpicker();
    });
})();