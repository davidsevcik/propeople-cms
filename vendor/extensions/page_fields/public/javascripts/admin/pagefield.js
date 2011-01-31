function addField(form) {
  if (validFieldName()) {
    new Ajax.Updater(
      $('attributes').down('tbody'),
      '/admin/pages/fields/',
      {
        asynchronous: true,
        evalScripts: true,
        insertion: 'bottom',
        onComplete: function(response){ fieldAdded(form); },
        onLoading: function(request){ fieldLoading(form); },
        parameters: Form.serialize(form)
      }
    );
  }
}
function removeField(button) {
  var row = $(button).up('tr');
  var name = row.down('label').innerHTML;
  if (confirm('Remove the "' + name + '" field?')) {
    row.down('.delete_input').setValue(true);
    row.down('.page_field_name').clear();
    row.hide();
  }
}
function fieldAdded(element) {
  $(element).previous('.busy').hide();
  $(element).down('.button').enable();
  $(element).up('.popup').closePopup();
  var field_index = $('page_field_counter').value;
  $('page_fields_attributes_' + field_index + '_content').focus();
  $('page_field_counter').setValue(Number(field_index).succ());
  $('new_page_field').reset();
}
function fieldLoading(element) {
  $(element).down('.button').disable();
  $(element).previous('.busy').appear();
}
function validFieldName() {
  var fieldName = $('page_field_name');
  var name = fieldName.value.downcase();
  if (name.blank()) {
    alert('Field name cannot be empty.');
    return false;
  }
  if (findFieldByName(name)) {
    alert('Field name must be unique.');
    return false;
  }
  return true;
}
function findFieldByName(name) {
  return $('attributes').select('input.page_field_name').detect(function(input) { return input.value.downcase() == name; });
}

var TextAreaResize = Class.create();

TextAreaResize.prototype = {

    /*
     * PROPERTIES
    */
    
    /*
     * 
     * OPTIONS:
     * maxRows: integer (default 50)
     * The maximum number of rows to grow the text area
     * 
    */
    
    
    /*
    * INITIALIZATION - CONFIGURATION
    */
    initialize: function(element, options) {
        this.element = $(element);        
        this.options = Object.extend({maxRows: 50}, options || {} );

        Event.observe(this.element, 'keyup', this.onKeyUp.bindAsEventListener(this));
        this.onKeyUp();
    },

    /*
    * PUBLIC FUNTIONS
    */    
    onKeyUp: function() {        
        while (this.element.scrollHeight > this.element.offsetHeight && this.element.rows < this.options.maxRows) {
            if (this.element.rows < this.options.maxRows) {
                this.element.rows = this.element.rows + 1;
            }
        }
    }
};

document.observe("dom:loaded", function() {
  $$('div.set').first().insert({before: $('attributes')});
  
  var editForm;
  if (editForm = $('edit_page')) editForm.writeAttribute('data-onsubmit_status', "Ukládáni změn&#8230;");
});


