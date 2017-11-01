$(document).on("click", "#addNewTask", function () {
  var link = $(this).data("href");
  $.ajax({
    url: link,
    type: "GET"
  });
});


$(document).on("click", "#tasksList tr", function () {
  var link = $(this).data("href");
  $.ajax({
    url: link,
    type: "GET"
  });
});

$(document).on("click", ".nav-pills .nav-item", function () {
    if ($(this).attr("id") != "all_tasks_filter"){
      $(".nav-item").children('.nav-link').removeClass("active");
      $(this).children('.nav-link').addClass("active");
      $.ajax({
        url: '/tasks/filter_tasks',
        type: "GET",
        data: {filter_id: $(this).attr("id")}
      });
    }   
});

$('.pagination').find('a').each(function() {
  $(this).attr("data-turbolinks", false);
});

function reloadTasks() {
  $("#taskFormCenter").modal("hide");
  var selected_tab_id = $('.nav-item .nav-link.active').closest("li").attr("id");

  if(selected_tab_id == "all_tasks_filter"){
    $.ajax({
        url: '/tasks/filter_tasks',
        type: "GET",
        data: {filter_id: selected_tab_id}
    })
  }
  else $("#" + selected_tab_id).click();
}