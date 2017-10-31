//sites_index
$(document).on("click", "#sitesList tr", function() {
  var link = $(this).data("href");
  $.ajax({
    url: link,
    type: "GET"
  });
});

$(document).on("click", "#createNewSite", function() {
  var link = $(this).data("href");
  $.ajax({
    url: link,
    type: "GET"
  });
});

//sites_form

$(document).on("click", "#sitesList tr", function() {
  var link = $(this).data("href");
  $.ajax({
    url: link,
    type: "GET"
  });
});

$(document).on("click", "#findContactDetails", function() {
  var link = $(this).data("href");
  $.ajax({
    url: link,
    type: "GET"
  });
});

$('.digg_pagination a').each(function () {
    $(this).attr("data-turbolinks", false);
});
