// Project Contacts

function reloadProjectContacts(id){
  $('.modal-backdrop').remove();
  $('#contactFormCenter').modal('hide');
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

$( document ).ready(function() {
  $('.digg_pagination a').each(function () {
    $(this).attr("data-turbolinks", false);
  })
});

//Projects

$(document).on("input", "#projectsNumber", function () {
  checkValidityofNumber("projects",this)
});

//notes

function reloadNotes(id){
  $.ajax({
    url: '/projects/' + id + '/notes',
    type: "GET"
  });
}

$(document).on("click", ".first-save-project", function () {
  alert("First save a project before accessing this section.");
});

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
    dataType: 'script',
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

//files

function reloadFiles(){
  $('.modal-backdrop').remove();
  $("#fileFormCenter").modal("hide");
  $.ajax({
    url: '/files',
    type: "GET",
    dataType: 'script'
  });  
}

$(document).on("click", ".spinnerButton", function () {
  this.innerHTML = 'Processing....';
  $('.spinner').removeAttr('hidden');
});

$(document).on("click", ".delete-clickable", function () {
  var result = confirm("Are you sure you want to delete this file?");
  if (result) {
    var link = $(this).data("href");
    $.ajax({
      url: link,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      type: "DELETE",
      dataType: 'script'
    });
  }
});

$(document).on("change", "#files_filter_by_project", function () {
  var project_id = $('#files_filter_by_project').val();
  $.ajax({
    url: "/files",
    type: "GET",
    data: { project_id: project_id },
    dataType: 'script'
  });
});

//project_files

function reloadProjectFiles(id){
  $('.modal-backdrop').remove();
  $("#fileFormCenter").modal("hide");
  $.ajax({
    url: '/projects/' + id + '/files',
    type: "GET",
  });
}

//project_sites

function reloadSites(id){
  $('.modal-backdrop').remove();
  $('#siteFormCenter').modal('hide');
  $.ajax({
    url: '/projects/' + id + '/sites',
    type: "GET"
  });
}

function tokenInputforContact() {
  $('#tokenContactName').tokenInput('/sites/find_contact.json', {
    crossDomain: false,
    hintText: 'Contact search',
    minChars: 2,
    tokenLimit: 1,
    resultsFormatter: function (item) {
        return "<li>" + "<div style='display: inline-block; padding-left: 10px;'><div class='full_name'>" + item.name + "</div><div class='email'>" + item.email + "</div></div></li>"
    },
    tokenFormatter: function (item) {
        return "<li><p>Name: " + item.name + "</p><br><p>Email: " + item.email + "</p><br><p>Phone: " + item.cell_phone + "</p></li>"
    },
    prePopulate: $('#tokenContactName').data('pre')
  });
};

// Company Contacts

function reloadCompanyContacts(id){
  $('.modal-backdrop').remove();
  $('#contactFormCenter').modal('hide');
  $.ajax({
    url: '/companies/' + id + '/contacts',
    type: "GET"
  });
}

// Company Projects

function reloadCompanyProjects(id){
  $('.modal-backdrop').remove();
  $.ajax({
    url: '/companies/' + id + '/projects',
    type: "GET"
  });
}

$(document).on("click", ".delete-option", function () {
  var link = $(this).data("href");
  $.ajax({
    url: link,
    type: "DELETE",
    dataType: 'script'
  });
});

//company_id_check

$(document).on("input", "#companiesNumber", function () {
  checkValidityofNumber('companies', this);
});

//Property number

$(document).on("input", "#sitesNumber", function () {
  checkValidityofNumber('sites', this);
});

function checkValidityofNumber(section_type, selected_element){
  var fieldValue = $(selected_element).val();
  var record_id = $("#" + section_type + "NumberMessage").attr("value");
  if(fieldValue.length<6 || isNaN(fieldValue)){
    $(selected_element).parent().removeClass("has-success");
    $(selected_element).parent().addClass("has-danger");
    $("#" + section_type + "NumberMessage").removeClass();
    $("#" + section_type + "NumberMessage").addClass("error");
    $("#" + section_type + "NumberMessage").html("Number must contain only 6 digits.");
  }
  else{
    $.ajax({
      url: "/" + section_type + "/check_" + section_type + "_number_validity",
      type: "GET",
      data: { data: fieldValue, id: record_id },
      dataType: "script"
    });
  } 
}

function updateViewAfterIdCheck(message_status, message_to_show, section_type){
  $("#"+ section_type +"NumberMessage").removeClass();
  if (message_status == "true") {
    $("#"+ section_type +"Number").parent().removeClass("has-danger");
    $("#"+ section_type +"Number").parent().addClass("has-success");
    $("#"+ section_type +"NumberMessage").addClass("success");
  }
  else{
    $("#"+ section_type +"Number").parent().removeClass("has-success");
    $("#"+ section_type +"Number").parent().addClass("has-danger");
    $("#"+ section_type +"NumberMessage").addClass("error");
  }
  $("#"+ section_type +"NumberMessage").html(message_to_show);
}

// reporting JS
$(document).on("click", "#businessTypeCharts", function () {
  if(this.href.indexOf("New") > -1)
    $('#hiddenBusinessType').val("New Business");
  else if (this.href.indexOf("Existing") > -1)
    $('#hiddenBusinessType').val("Existing Business");
  else $('#hiddenBusinessType').val("");

  var link = this.href;
  $.ajax({
    url: link,
    type: "GET",
    dataType: 'script'
  });
});

$(document).on("click", "#xls-report-btn", function () {
  $('#hiddenReportFormat').val("xls");
});
$(document).on("click", "#pdf-report-btn", function () {
  $('#hiddenReportFormat').val("pdf");
});
$(document).on("click", "#downloadGeneratedReportModal .green-btn", function () {
  $('#downloadGeneratedReportModal').modal("hide");
});

//Activities

$(document).on("click", ".first-save-activity", function () {
  alert("First save a activity before accessing this section.");
});

//ActivityNotes

function reloadActivityNotes(id){
  $.ajax({
    url: '/activities/' + id + '/notes',
    type: "GET"
  });
}

//ActivityFiles

function reloadActivityFiles(id){
  $('.modal-backdrop').remove();
  $("#fileFormCenter").modal("hide");
  $.ajax({
    url: '/activities/' + id + '/files',
    type: "GET",
  });
}

//ActivityTasks

function reloadActivityTasks(id){
  $.ajax({
    url: '/activities/' + id + '/tasks',
    type: "GET",
  });
}

$(document).on("change", "#activities_filter_by_company", function () {
  var company_id = $('#activities_filter_by_company').val();
  $.ajax({
    url: "/activities",
    type: "GET",
    dataType: 'script',
    data: { company_id: company_id }
  });  
});

//Activity Number Check
$(document).on("input", "#activitiesNumber", function () {
  checkValidityofNumber('activities', this);
});
