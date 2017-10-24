//contacts_index
$(document).on("click", "#contactsList tr", function () {
  var link = $(this).data("href");
  $.ajax({
    url: link,
    type: "GET"
  });
});

$(document).on("click", "#createNewContact", function () {
  var link = $(this).data("href");
  $.ajax({
    url: link,
    type: "GET"
  });
});

function showUploadFileName(input) {
  if (input.files && input.files[0]) {
    $('.fileName').html(input.files[0].name);
  }
}

$(document).on("click", "#fakeFileUploadBtn", function () {
  $('#contactsFileUploadHidden').click();
});
$("#contactsFileUploadHidden").change(function () {
  showUploadFileName(this);
});

$('.digg_pagination a').each(function () {
  $(this).attr("data-turbolinks", false);
})