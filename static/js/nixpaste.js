(function(){
	$("#acecontainer").show();
	var defaultMode = window.location.search.substring(1) || "nix";
	
	var editor = ace.edit("editor");
	editor.setTheme("ace/theme/github");
	editor.getSession().setMode("ace/mode/"+defaultMode);
	editor.renderer.setScrollMargin(10, 10, 10, 10);
	editor.renderer.setPadding(10, 10, 10, 10);
	editor.renderer.setShowGutter(false);
	editor.setShowPrintMargin(false);
	editor.setFontSize(16);
	editor.setHighlightActiveLine(false);

	// List ace language
	var modelist = ace.require("ace/ext/modelist");
	var topModes = [["nix", "Nix"], ["sh", "Shell"], ["perl", "Perl"]];
	var optionsStr = '';
	for (var i in topModes) {
		var m = topModes[i];
		var selected = defaultMode == m[0] ? 'selected="selected"' : "";
		optionsStr += '<option value="'+m[0]+'" '+selected+'>'+m[1]+'</option>\n';
	}
	optionsStr += '<option data-divider="true"></option>';
	
	for (var i in modelist.modes) {
		var mode = modelist.modes[i];
		if (mode.name == "nix" || mode.name == "sh" || mode.name == "perl") {
			continue;
		}
		var selected = defaultMode == mode.name ? 'selected="selected"' : "";
		optionsStr += '<option value="'+mode.name+'"'+selected+'>'+mode.caption+'</option>\n';
	}

	// Add languages to a cool select picker
	$(".selectpicker").html(optionsStr).change(function(ev) {
			editor.getSession().setMode("ace/mode/"+ev.currentTarget.value);
	});

	// Add font size slider
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

	// Set value to the hidden input
	$("#ace-form").attr("name", "browser_text");
	$("form").submit (function () {
			$("#ace-form").val (editor.getSession().getValue());
	})
})();