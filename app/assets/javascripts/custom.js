// Project Contacts

function reloadProjectContacts(id) {
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

$(document).ready(function () {
  $('.digg_pagination a').each(function () {
    $(this).attr("data-turbolinks", false);
  })
});

//Projects

$(document).on("input", "#projectsNumber", function () {
  checkValidityofNumber("projects", this)
});

//notes

function reloadNotes(id) {
  $.ajax({
    url: '/projects/' + id + '/notes',
    type: "GET"
  });
}

$(document).on("click", ".first-save-project", function () {
  alert("First save a project before accessing this section.");
});

//tasks

$(document).on("click", ".tasksNav .nav-item", function () {
  $(".nav-item").children('.nav-link').removeClass("active");
  $(this).children('.nav-link').addClass("active");
  $(this).attr("id") == "current_user_filter" ? $('.assign-filter').attr('hidden', false) : $('.assign-filter').attr('hidden', true);
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

$(document).on("change", "#filter_by_status", function () {
  filterRequest();
});

function filterRequest() {
  var project_id = $('#task_filter_by_project').val();
  var user_filter = ($('#current_user_filter .nav-link').hasClass("active"));
  var assigned_to_me = ($('#assign').val() == "Assigned To Me");
  var status = $('#filter_by_status').val();
  $.ajax({
    url: "/tasks",
    type: "GET",
    dataType: 'script',
    data: {current_user_filter: user_filter, project_id: project_id, assigned_to_me: assigned_to_me, status: status}
  });
}

//project_tasks

function reloadProjectTasks(id) {
  $.ajax({
    url: '/projects/' + id + '/tasks',
    type: "GET",
  });
}

//files

function reloadFiles() {
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
      beforeSend: function (xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
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
    data: {project_id: project_id},
    dataType: 'script'
  });
});

//project_files

function reloadProjectFiles(id) {
  $('.modal-backdrop').remove();
  $("#fileFormCenter").modal("hide");
  $.ajax({
    url: '/projects/' + id + '/files',
    type: "GET",
  });
}

//project_sites

function reloadSites(id) {
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
      return "<li>" + "<div class='res_formatter'><div class='full_name'>" + item.name + "</div><div class='email'>" + item.email + "</div></div></li>"
    },
    tokenFormatter: function (item) {
      return "<li><p>Name: " + item.name + "</p><br><p>Email: " + item.email + "</p><br><p>Phone: " + item.cell_phone + "</p></li>"
    },
    prePopulate: $('#tokenContactName').data('pre')
  });
};

// Company Contacts

function reloadCompanyContacts(id) {
  $('.modal-backdrop').remove();
  $('#contactFormCenter').modal('hide');
  $.ajax({
    url: '/companies/' + id + '/contacts',
    type: "GET"
  });
}

// Company Projects

function reloadCompanyProjects(id) {
  $('.modal-backdrop').remove();
  $.ajax({
    url: '/companies/' + id + '/projects',
    type: "GET"
  });
}

$(document).on("click", ".delete-option", function () {
  var link = $(this).data("href");
  if(confirm("Are you sure?")){
    $.ajax({
      url: link,
      type: "DELETE",
      dataType: 'script'
    });
  }
});

//company_id_check

$(document).on("input", "#companiesNumber", function () {
  checkValidityofNumber('companies', this);
});

//Property number

$(document).on("input", "#sitesNumber", function () {
  checkValidityofNumber('sites', this);
});

function checkValidityofNumber(section_type, selected_element) {
  var fieldValue = $(selected_element).val();
  var record_id = $("#" + section_type + "NumberMessage").attr("value");
  if (fieldValue.length < 6 || isNaN(fieldValue)) {
    $(selected_element).parent().removeClass("has-success");
    $(selected_element).parent().addClass("has-danger");
    $("#" + section_type + "NumberMessage").removeClass();
    $("#" + section_type + "NumberMessage").addClass("error");
    $("#" + section_type + "NumberMessage").html("Number must contain only 6 digits.");
  }
  else {
    $.ajax({
      url: "/" + section_type + "/check_" + section_type + "_number_validity",
      type: "GET",
      data: {data: fieldValue, id: record_id},
      dataType: "script"
    });
  }
}

function updateViewAfterIdCheck(message_status, message_to_show, section_type) {
  $("#" + section_type + "NumberMessage").removeClass();
  if (message_status == "true") {
    $("#" + section_type + "Number").parent().removeClass("has-danger");
    $("#" + section_type + "Number").parent().addClass("has-success");
    $("#" + section_type + "NumberMessage").addClass("success");
  }
  else {
    $("#" + section_type + "Number").parent().removeClass("has-success");
    $("#" + section_type + "Number").parent().addClass("has-danger");
    $("#" + section_type + "NumberMessage").addClass("error");
  }
  $("#" + section_type + "NumberMessage").html(message_to_show);
}

// reporting JS
$(document).on("click", "#businessTypeCharts", function () {
  if (this.href.indexOf("New") > -1)
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

$(document).on("click", "#filter-periodic-report", function () {
  var link = this.href;
  $.ajax({
    url: link,
    type: "GET",
    dataType: 'script',
    data: {
      year: $('#yearToStartReport').val(),
      year_to_compare: $('#yearToCompareReport').val(),
      type: $('#hiddenBusinessType').val()
    }
  });
});

$(document).on("click", "#filter-monthly-report", function () {
  var link = this.href;
  $.ajax({
    url: link,
    type: "GET",
    dataType: 'script',
    data: {
      start_date: $('#filterToStartReport').val(),
      end_date: $('#filterToEndReport').val(),
      type: $('#hiddenBusinessType').val()
    }
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

function reloadActivityNotes(id) {
  $.ajax({
    url: '/activities/' + id + '/notes',
    type: "GET"
  });
}

//ActivityFiles

function reloadActivityFiles(id) {
  $('.modal-backdrop').remove();
  $("#fileFormCenter").modal("hide");
  $.ajax({
    url: '/activities/' + id + '/files',
    type: "GET",
  });
}

//ActivityTasks

function reloadActivityTasks(id) {
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
    data: {company_id: company_id}
  });
});

//Activity Number Check
$(document).on("input", "#activitiesNumber", function () {
  checkValidityofNumber('activities', this);
});

// Dashboard JS
$(document).on("change", "#dashboard_task_by_project", function () {
  taskFilterRequest($('.dashboard-menu .viewTaskReport li.viewlink').text());
});
$(document).on("click", ".dashboard-menu .viewTaskReport li", function () {
  taskFilterRequest($(this).text());
});

function taskFilterRequest(filter_by) {
  var project_id = $('#dashboard_task_by_project').val();
  $('.dashboard-menu .viewTaskReport li.viewlink').removeClass('viewlink');
  var filter = 'all_tasks';
  if (filter_by.indexOf("All Tasks") > -1) {
    $('.dashboard-menu .viewTaskReport li:first-child').addClass('viewlink');
  }
  else{
    $('.dashboard-menu .viewTaskReport li:nth-child(2)').addClass('viewlink');
    filter = 'my_tasks'
  }

  $.ajax({
    url: "/dashboard/tasks",
    type: "GET",
    dataType: 'script',
    data: { project_id: project_id, filter: filter  }
  });
}

$(document).on("change", "#dashboard_activity_select", function () {
  activityFilterRequest($('.dashboard-menu #activityReportFilter li.viewlink').text());
});
$(document).on("click", ".dashboard-menu #activityReportFilter li", function () {
  activityFilterRequest($(this).text());
});

function activityFilterRequest(filter_by) {
  var activity_type = $('#dashboard_activity_select').val();
  $('.dashboard-menu #activityReportFilter li.viewlink').removeClass('viewlink');
  var filter = null;
  if (filter_by.indexOf("Combined") > -1) {
    $('.dashboard-menu #activityReportFilter li:nth-child(3)').addClass('viewlink');
  }else if (filter_by.indexOf("Attraction") > -1) {
    $('.dashboard-menu #activityReportFilter li:nth-child(1)').addClass('viewlink');
    filter = 'New Business'
  }else{
    $('.dashboard-menu #activityReportFilter li:nth-child(2)').addClass('viewlink');
    filter = 'Existing Business'
  }

  $.ajax({
    url: "/dashboard/activity",
    type: "GET",
    dataType: 'script',
    data: { activity: activity_type, type: filter  }
  });
}
$(document).on("change", "#dashboard_email_by_project", function () {
  filterDashboardEmails();
});
$(document).on("change", "#dashboard_email_by_contact", function () {
  filterDashboardEmails();
});

function filterDashboardEmails(){
  $.ajax({
    url: "/dashboard/emails",
    type: "GET",
    dataType: 'script',
    data: { project: $('#dashboard_email_by_project').val(), contact: $('#dashboard_email_by_contact').val()  }
  });
}

function reloadUsers(){
  $('.modal-backdrop').remove();
  $('#invitationFormCenter').modal('hide');
  $.ajax({
    url: '/manage_users',
    type: "GET",
    dataType: 'script'
  });
}

$(document).on("click", "#custom-export-projects-btn", function () {
  $('#hiddenExportField').val("true");
});
$(document).on("click", "#basic-export-projects-btn", function () {
  $('#hiddenExportField').val("false");
});

function checkAll(ele) {
  if (ele.checked) {
    $(".custom-export-checkboxes input:checkbox").prop("checked", true);
  } else {
    $(".custom-export-checkboxes input:checkbox").prop("checked", false);
  }
}

$(document).on("click", "#export-all-companies-btn", function () {
  $('#exportAllCompanies').val("true");
});
$(document).on("click", "#export-companies-btn", function () {
  $('#exportAllCompanies').val("false");
});

function saveCustomConfig() {
  var path = '/custom_exports/save_custom_configs';
  customConfigRequest(path);
}

function customConfigRequest(path) {
  var name = $('#customOptionName').val();
  if (name) {
     var checked_options = $(":checked").map(function(){return $(this).attr("id");}).get();
    $.ajax({
      url: path,
      type: "POST",
      data: { name: name, options: checked_options}
    });
  }
  else {
    alert('Name can not be blank!');
  }
}

function applyCustomOption(id, filters, name) {
  applyfilters(filters, name);
  $('.custom_export_tr').removeClass('active_custom_export');
  $('.custom_export_'+id).addClass('active_custom_export');

  $('#customOptionName').val(null);
  $('.save-custom-config').html('Save');
  $('.save-custom-config').attr("onclick", "saveCustomConfig()");
}

function applyfilters(filters, name) {
  var checkboxes = document.getElementsByClassName('custom-export-chk');
  for (var i = 0; i < checkboxes.length; i++) {
    if ((checkboxes[i].type == 'checkbox') && (filters.includes(checkboxes[i].id))) {
      checkboxes[i].checked = true;
    }
    else {
      checkboxes[i].checked = false;
    }
  };
}

$(document).on("click", ".edit-custom-export", function () {
  var name = $(this).data("name");
  var filters = $(this).data("filters");
  var custom_export_id = $(this).data("custom_id");

  applyfilters(filters, name);
  $('.custom_export_tr').removeClass('active_custom_export');
  $('.custom_export_'+custom_export_id).addClass('active_custom_export');

  $('#customOptionName').val(name);
  $('.save-custom-config').html('Update');
  $('.save-custom-config').attr("onclick", "editCustomConfig("+custom_export_id+")");
});

function editCustomConfig(id) {
  var path = '/custom_exports/'+ id +'/edit_custom_configs';
  customConfigRequest(path);
}
$(document).on("change", "#project_square_feet_requested", function () {
  show_hide_div_content(this, '#otherSquareFeetRequested', 'Other')
});

// Toggle the where located field
$(document).on("click", "input[name*='status']", function() {
  show_hide_div_content(this, '#where_located_div', 'Successful')
});

// To change the value of progress in tasks to 100.00 on completion
$(document).on("change", "#task_status", function() {
  if ($(this).val() == 'Complete')
    $('#task_progress').val('100.0')
  else
    $('#task_progress').val('0.0')
});

$(function() {
  $('#siteVisitDates').on('cocoon:after-insert', function(e, inserted_item) {
    $('#siteVisitDates .nested-fields').each(function (indx) {
      var label_no = indx + 1;
      $(this).find('.visitDateLabel').html("Site Visit " + label_no + ":")
    });
  });
  $('#siteVisitDates').on('cocoon:after-remove', function(e, inserted_item) {
    $('#siteVisitDates .nested-fields').each(function (indx) {
      var label_no = indx + 1;
      $(this).find('.visitDateLabel').html("Site Visit " + label_no + ":")
    });
  });
});

$(document).ready(function () {
  $('#siteVisitDates .nested-fields').each(function (indx) {
    var label_no = indx + 1;
    $(this).find('.visitDateLabel').html("Site Visit " + label_no + ":")
  });
});

$(document).on("change", "#project_company_id", function () {
  if ($(this).val() === '0'){
    $('#quick_add_company').removeClass('hidden');
    $('#project_new_company_name').attr('required', true);
  }
  else{
    $('#quick_add_company').addClass('hidden');
    $('#project_new_company_name').attr('required', false);
  }
});

// Toggle the public release date and elimination reason fields
$(document).on("click", "input[name*='status']", function() {
  show_hide_div_content(this, '.publicRelease-and-elimination', 'Successful')
});

function show_hide_div_content(object, div, value_to_be_compared) {
  if (object.value == value_to_be_compared){
    $(div).removeClass('hidden');
  }
  else{
    $(div).addClass('hidden');
  }
}

$(document).on("change", "#activity_company_activity_type_id", function () {
  $('#manageConfigMessage').html('');
  $("#new_activity_type").parent().removeClass("has-danger");
  convert_text_field($(this).val(), '.manage_config_div', '.target-dropdown', 'Quick add');
});

$(document).on("click", ".cancel-quick-add", function () {
  convert_text_field('', '.manage_config_div', '.target-dropdown', 'Quick add');
  $('#activity_company_activity_type_id').val('');
});

function convert_text_field(object_value, div, target_div, value_to_be_compared) {
  if (object_value == value_to_be_compared){
    $(div).removeClass('hidden');
    $(target_div).addClass('hidden');
  }
  else{
    $(div).addClass('hidden');
    $(target_div).removeClass('hidden')
  }
}

$(document).on("click", ".add-activity-type", function () {
  if ($('#new_activity_type').val()) {
    $.ajax({
      url: '/manage_configurations',
      type: "POST",
      data: { type: 'company_activity_types', company_activity_type: { name: $('#new_activity_type').val() }, respond_to_ajax: true },
      success: function(data) {
        $('#activity_company_activity_type_id').prepend("<option value=" + data.id + " selected='selected'>" + data.name + "</option>");
        $('.manage_config_div').addClass('hidden');
        $('.target-dropdown').removeClass('hidden');
        $('#new_activity_type').val('');
      }
    });
  } else {
    $("#new_activity_type").parent().addClass("has-danger");
    $('#manageConfigMessage').html("This field can't be blank");
  }
});

function markReadSectionRequest(section, org_id, user_id) {
  $.ajax({
    url: '/organizations/' + org_id + '/users/' + user_id + '/mark_section_as_read',
    type: "PATCH",
    data: { section: section }
  });
}

function getSectionInformation(value) {
  var org_id = $('.section-info-icon').data('org-id');
  var user_id = $('.section-info-icon').data('user-id');
  var section = $('.section-info-icon').data('section');
  $.ajax({
    url: '/organizations/' + org_id + '/users/' + user_id + '/get_section_information',
    type: "GET",
    data: { section: section, show_anyway: value}
  });
}

$(document).on('turbolinks:load', function() {
  setTimeout(function() {
    if ($('.section-info-icon').data('user-id')) {
      getSectionInformation(false);
    }
  }, 200);
})

$(document).on("change", "#dashboard_project_by_status, #dashboard_project_by_project_type", function () {
  $.ajax({
    url: "/dashboard/projects",
    type: "GET",
    dataType: 'script',
    data: { status: $('#dashboard_project_by_status').val(), project_type_id: $('#dashboard_project_by_project_type').val()  }
  });
});