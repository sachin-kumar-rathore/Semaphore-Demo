$(document).on("click", "#projectsList tr", function () {
  var link = $(this).data("href");
  window.location.href = link;
});

$('.digg_pagination a').each(function () {
  $(this).attr("data-turbolinks", false);
})