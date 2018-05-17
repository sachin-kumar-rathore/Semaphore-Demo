$(document).ready(function (){
  $('.step-form fieldset:first-of-type').fadeIn('slow');
  
  // next step
  $('.step-form .btn-next').on('click', function () {
    $(".step-form").validate({
      rules: {
      "user[password]": {required: true, minlength: 6},
      "user[password_confirmation]": {required: true, equalTo: "#pwd"}
      },
      messages: {
        "user[password_confirmation]": {
          equalTo : "Passwords don't match."
        }
      }
    });
    if ($('.step-form').valid()) {
      var parent_fieldset = $(this).parents('fieldset');
      var next_step = true;
      if (next_step) {
        parent_fieldset.fadeOut(400, function () {
          $(this).next().fadeIn();
        });
        var $next, $selected = $(".formSteps > ul > li.active");
        $next = $selected.next('li').length ? $selected.next('li') : $first;
        $selected.removeClass("active");
        $next.addClass('active');
      }
    }
    else{
      $('.step-form').validate();
    }
  });
  
  // previous step
  $('.step-form .btn-previous').on('click', function () {
    $(this).parents('fieldset').fadeOut(400, function () {
      $(this).prev().fadeIn();
    });
    var $next, $selected = $(".formSteps > ul > li.active");
    $prev = $selected.prev('li').length ? $selected.prev('li') : $last;
    $selected.removeClass("active");
    $prev.addClass('active');
  });
});


$('.chooseMethod  input[type="radio"]').click(function(){
  $(this).parents('.choosePaymentSection').find('#paymentId').attr('class', '').addClass($(this).val());
});
$('#paymentId').attr('class', '').addClass($('.chooseMethod  input[type="radio"]:checked').val());