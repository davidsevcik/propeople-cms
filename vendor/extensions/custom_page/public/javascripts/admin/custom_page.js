Event.addBehavior({

  '#site_map .add_child a:click': function(event) {
    var link = $(event.target);
      

    Modalbox.show(new_page_form, {title: 'Nová podstránka', width: 500, afterLoad: function() {
      var new_page_form = $('new_page_form');
      new_page_form.parent_id.setValue(link.href.match(/(\d+)\/children\/new$/)[1]);  
      $('page_title').setValue('');
      $('page_type').setValue('NormalPage');   
    }});
    

    event.stop();
  }/*,
  
  '#edit_page #translations a:click': function(event) {
    var link = $(event.target);
    var new_page_form = $('new_page_form');

    new_page_form.action = link.href;
    new_page_form.page_title.setValue('');

    Modalbox.show(new_page_form, {title: 'Překlad stránky', width: 500});

    event.stop();
  }*/
});


document.observe("dom:loaded", function() {
  var page_form = $('edit_page');

  if (page_form) {
    var buttons_area = page_form.down('.buttons');

    if (buttons_area) {
      buttons_area.setStyle({clear: 'both'});
      var statuses = ['1', '20', '21'];
    
      if (statuses.indexOf($('page_status_id').getValue()) != -1) {
        buttons_area.insert({
          top: '<input type="submit" class="button" name="continue" value="Publikovat" id="publish_button" accesskey="p" />'
        });

        $('publish_button').observe('click', function(event) {
          $('page_status_id').setValue('100');
        });
      }

      buttons_area.insert({
        bottom: 'nebo <a href="'+page_form.action+'/remove" class="delete">Smazat</a>'
      });
    }

    $('published_at').remove();
    //$('page_class_name').down(0).remove();
  }
});
