// Helper function to get parameters from the query string.
function getUrlParam(paramName)
{
  var reParam = new RegExp('(?:[\?&]|&amp;)' + paramName + '=([^&]+)', 'i') ;
  var match = window.location.search.match(reParam) ;
 
  return (match && match.length > 1) ? match[1] : '' ;
}


document.observe("dom:loaded", function() {
  
  $$('#attachment_list a').each(function(link) {
    link.observe('click', function(event) {
      var funcNum = getUrlParam('CKEditorFuncNum');
      window.opener.CKEDITOR.tools.callFunction(funcNum, link.href);
      window.close();
      event.stop();
    });
  }); 
    
});

