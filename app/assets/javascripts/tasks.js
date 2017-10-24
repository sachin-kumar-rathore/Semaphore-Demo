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
    $(".nav-item").children('.nav-link').removeClass("active");
    $(this).children('.nav-link').addClass("active");
    if ($(this).attr("id") != "all_tasks_filter"){
      $.ajax({
        url: '/tasks/filter_tasks',
        type: "GET",
        data: {filter_id: $(this).attr("id")}
      });
    }   
});
