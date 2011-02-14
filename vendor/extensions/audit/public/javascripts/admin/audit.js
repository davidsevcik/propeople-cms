// Generic Overlabel for in-field label
var OverLabel = Behavior.create({
	initialize : function(){
		this.element.hide();
		this.overlabel = this.element.innerHTML;
		this.input = $(this.element.htmlFor);
		if (!this.overLabelIsWriteable()) return;
		this.initializeOverLabel();
		this.element.up('form').observe("submit", this.clearOverLabelValue.bind(this));
	},
	initializeOverLabel : function(){
		this.input.observe('click', this.overLabelFocusHandler.bindAsEventListener(this)).value = this.overlabel;
	},
	overLabelFocusHandler : function(){
		if (this.overLabelIsWriteable) {
			this.input_blur_handler = this.overLabelBlurHandler.bindAsEventListener(this);
			this.input.observe('blur', this.input_blur_handler).clear();
		}
	},
	overLabelBlurHandler : function(){
		Event.stopObserving(this.input, 'blur', this.input_blur_handler);
		if ($F(this.input).empty())
			this.replaceOverLabel();
	},
	replaceOverLabel : function(){
		this.input.value = this.overlabel;
	},
	overLabelIsWriteable : function(){
		var val = $F(this.input);
		return val == "" || val == this.overlabel;
	},
	clearOverLabelValue : function(){
		if (this.input.value == this.overlabel)
			this.input.clear();
	}
});

var AuditController = Behavior.create({
	initialize : function(){
		this.metadata_toggler = $("more-or-less-metadata");
		this.metadata = $("filtering-options");
		if (!this.metadata_toggler || !this.metadata) return;
		this.metadata_toggler.observe("click", this.toggleFilteringOptions.bind(this));
		if (document.location.href.indexOf("Filter") > -1)
			this.toggleFilteringOptions();
	},
	toggleFilteringOptions : function(){
		this.metadata.toggleClassName("Active");
		this.metadata_toggler.update(this.metadata_toggler.innerHTML.indexOf("Show") > -1 ? "Hide Filters" : "Show Filters");
	}
});

// And add our behaviors
Event.addBehavior({
	".OverLabel" : OverLabel,
	"#actions" : AuditController
});