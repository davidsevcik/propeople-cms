function instantiateCkEditor(partIndex){
	CKEDITOR.config.startupOutlineBlocks = true;
	CKEDITOR.config.colorButton_enableMore = false;
	CKEDITOR.config.protectedSource.push( /<r:([\S]+)*>.*<\/r:\1>/g );
	CKEDITOR.config.protectedSource.push( /<r:[^>\/]*\/>/g );
	CKEDITOR.config.toolbar =
	[
	    ['Source'],
      ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'],
      ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
      ['Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField'],
      '/',
      ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
      ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote','CreateDiv'],
      ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
      ['BidiLtr', 'BidiRtl'],
      ['Link','Unlink','Anchor'],
      ['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe'],
      '/',
      ['Styles','Format','Font','FontSize'],
      ['TextColor','BGColor'],
      ['Maximize', 'ShowBlocks','-','About']
	];
	
	
	CKEDITOR.config.filebrowserBrowseUrl = '/admin/page_attachments/ckeditor_browser';
	CKEDITOR.config.filebrowserWindowWidth = '800';
  CKEDITOR.config.filebrowserWindowHeight = '600';
	CKEDITOR.config.filebrowserUploadUrl = '/admin/page_attachments';
	CKEDITOR.config.entities = false;
	
	
	var usedFilter = $('part_' + partIndex +'_filter_id');
	if(usedFilter.value == 'CKEditor'){
		putInEditor(partIndex);
	}
}

function toggleEditor(partIndex){
	var filterId = $('part_' + partIndex + '_filter_id');
	if(filterId.value == 'CKEditor'){
		putInEditor(partIndex);
	} else {
		removeEditor(partIndex);
	}
}

function removeEditor(partIndex){
	var instance = CKEDITOR.instances['part_'+ partIndex +'_content']
	instance.destroy()
}

function putInEditor(partIndex){
	var textarea = $('part_' + partIndex + '_content');
	// replace radius tags with 
	
	CKEDITOR.replace(textarea);
}

