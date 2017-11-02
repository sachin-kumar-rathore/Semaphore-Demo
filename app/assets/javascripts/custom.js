// Project Contacts

function reloadContacts(id){
  $.ajax({
    url: '/project_contacts',
    type: "GET",
    data: { project_id: id}
  });
}

// Contacts

$(document).on("click", ".clickable", function () {
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

$( document ).ready(function() {
  $('.digg_pagination a').each(function () {
    $(this).attr("data-turbolinks", false);
  })
});

//Projects

$(document).on("click", "#projectsList tr", function () {
  var link = $(this).data("href");
  window.location.href = link;
});

$(function() { 
  if (!$(".tab-content").children('.tab-pane').hasClass("active")){
    var link = $('#mainNavLink').attr("href");
    $.ajax({
      url: link,
      type: "GET"
    });
  }
});

//notes

function reloadNotes(id){
  $.ajax({
    url: '/notes',
    type: "GET",
    data: { project_id: id}
  });
}