$('#tokenContactName').tokenInput('/sites/find_contact.json', {
  crossDomain: false,
  hintText: 'Contact search',
  minChars: 2,
  tokenLimit: 1,
  resultsFormatter: function(item) {
    return "<li>" + "<div style='display: inline-block; padding-left: 10px;'><div class='full_name'>" + item.name + "</div><div class='email'>" + item.email + "</div></div></li>"
  },
  tokenFormatter: function(item) {
    return "<li><p>Name: " + item.name + "</p><br><p>Email: " + item.email + "</p><br><p>Phone: " + item.cell_phone + "</p></li>"
  },
  prePopulate: $('#tokenContactName').data('pre')
});