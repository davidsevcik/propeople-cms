Event.addBehavior({

  '#site_map .add_child a:click': function(event) {
    var link = $(event.target);
    var new_page_form = $('new_page_form');

    new_page_form.action = link.href;
    new_page_form.page_title.setValue('');
    new_page_form.page_type.setValue('');

    Modalbox.show(new_page_form, {title: 'Nová podstránka', width: 500});

    event.stop();
  }
});


document.observe("dom:loaded", function() {
  var page_form = $('edit_page');

  if (page_form) {
    var buttons_area = page_form.down('.buttons');

    if (buttons_area) {
      if ($('page_status_id').getValue() == '1') {
        buttons_area.insert({
          top: '<input type="submit" class="button" name="publish" value="Publikovat" id="publish_button" accesskey="p" />'
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
  }
});
