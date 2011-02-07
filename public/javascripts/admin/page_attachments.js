Event.addBehavior({

  '#attachment_list': function() {
    Sortable.create('attachment_list', {
      onUpdate: function(container) {
        container.select(".attachment").each(function(e, i) {
          e.down('input[name*="position"]').setValue(i+1);
        });
      }
    });
  },
  
  '#attachments:click': function(event) {
    var target = $(event.target);
    /*if (target.match('img[alt=add]') || target.match('a.add-link')) {
      var upload = '<div class="attachment_upload"><p class="title">Nahrát soubor</p><table><tr><th><label for="title_input">Titulek:</label></th><td><input id="title_input" size="60" name="page[attachments_attributes][][title]"></td></tr><tr><th><label for="description_input">Popisek:</label></th><td><input id="description_input" type="text" size="60"  name="page[attachments_attributes][][description]"></td></tr>' 
                 + '<tr><th><label for="flag">Příznak:</label></th><td><select name="flag"><option value="">žádný</option><option value="">nový příznak</option></select> <input type="text" name="new_flag" /></td></tr>'
                 + '<tr><th><label for="file_input">Soubor:</label></th><td><input id="file_input" type="file" size="60" name="page[attachments_attributes][][uploaded_data]" /><img src="/images/admin/minus.png" alt="cancel" /></td></tr></table></div>';
      
      
    } else */ if (target.match('img[alt=cancel]')) {
      event.findElement('.attachment_upload').remove();
      event.stop();
    } else if (target.match('img[alt=delete]')) {
      var attachment = event.findElement('.attachment');
      attachment.addClassName('deleted');
      attachment.insert("<em>Attachment will be deleted when page is saved.</em>");
      attachment.down('input[name*="_destroy"]').setValue('true');
    }
  },
  
  '#edit_page:submit': function(event) {
    $('attachment_upload_blueprint').remove();
    $$('div.attachment_upload select.flag_select').each(function(flagSelect) {
      if (flagSelect.getValue() == 'new_flag') {
        flagSelect.next('input[name=new_flag]').writeAttribute('name', flagSelect.name);
        flagSelect.remove();
      }
    });
  },
  
  '#attachments a.add-link:click': function(event) {
    var attachmentUpload = $('attachment_upload_blueprint').clone(true);
    attachmentUpload.writeAttribute('id', null);
    
    var attachmentIndex = parseInt($('attachment_index_field').value) + 1;
    attachmentUpload.select('input, select').each(function(elm) {
      elm.name = elm.name.gsub(/\[\]/, '[' + attachmentIndex + ']')
    });
    
    $('attachment_index_field').value = attachmentIndex;
    $('attachments').insert(attachmentUpload);
    
    var flagSelect = attachmentUpload.select('select.flag_select')[0];
    Event.observe(flagSelect, 'change', function(event) {
      if (flagSelect.getValue() == 'new_flag') {
        flagSelect.next('input[name=new_flag]').show();
      } else {
        flagSelect.next('input[name=new_flag]').hide();
      }
    });
    
    Event.observe(attachmentUpload.select('img[alt=cancel]')[0], 'click', function(event) {
      event.findElement('.attachment_upload').remove();
      event.stop();
    });
    
    event.stop();
  }

});
