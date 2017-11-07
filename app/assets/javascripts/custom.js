// Project Contacts

function reloadContacts(id){
  $.ajax({
    url: '/projects/' + id + '/contacts',
    type: "GET"
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

//notes

function reloadNotes(id){
  $.ajax({
    url: '/projects/' + id + '/notes',
    type: "GET"
  });
}

//tasks

$(document).on("click", ".nav-pills .nav-item", function () {
  $(".nav-item").children('.nav-link').removeClass("active");
  $(this).children('.nav-link').addClass("active");
  $(this).attr("id")=="current_user_filter" ? $('.assign-filter').attr('hidden',false) : $('.assign-filter').attr('hidden',true);
  filterRequest(); 
});


function reloadTasks() {
  $('.modal-backdrop').remove();
  $("#taskFormCenter").modal("hide");
  filterRequest();
}

$(document).on("change", "#task_filter_by_project", function () {
  filterRequest();
});

$(document).on("change", "#assign", function () {
  filterRequest();
});

function filterRequest(){
  var project_id = $('#task_filter_by_project').val();
  var user_filter = ($('#current_user_filter .nav-link').hasClass("active"));
  var assigned_to_me = ($('#assign').val()=="Assigned To Me");
  $.ajax({
    url: "/tasks",
    type: "GET",
    data: { current_user_filter: user_filter, project_id: project_id, assigned_to_me: assigned_to_me  }
  });  
}

//project_tasks

function reloadProjectTasks(id){
  $.ajax({
    url: '/projects/' + id + '/tasks',
    type: "GET",
  });
}


