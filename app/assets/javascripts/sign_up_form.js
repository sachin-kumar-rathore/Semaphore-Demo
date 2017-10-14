$(document).ready(function() {
  var animating, current_fs, left, next_fs, opacity, previous_fs, scale;
  $('#msform').validate();
  current_fs = void 0;
  next_fs = void 0;
  previous_fs = void 0;
  left = void 0;
  opacity = void 0;
  scale = void 0;
  animating = void 0;
  $('.next').click(function() {
    if ($('#msform').valid()) {
      if (animating) {
        return false;
      }
      animating = true;
      current_fs = $(this).parent();
      next_fs = $(this).parent().next();
      $('#progressbar li').eq($('fieldset').index(next_fs)).addClass('active');
      next_fs.show();
      current_fs.animate({
        opacity: 0
      }, {
        step: function(now, mx) {
          scale = 1 - ((1 - now) * 0.2);
          left = now * 50 + '%';
          opacity = 1 - now;
          current_fs.css({
            'transform': 'scale(' + scale + ')'
          });
          next_fs.css({
            'left': left,
            'opacity': opacity
          });
        },
        duration: 800,
        complete: function() {
          current_fs.hide();
          animating = false;
        },
        easing: 'easeInOutBack'
      });
    } else {
      $('#msform').validate();
    }
  });
  $('.previous').click(function() {
    if (animating) {
      return false;
    }
    animating = true;
    current_fs = $(this).parent();
    previous_fs = $(this).parent().prev();
    $('#progressbar li').eq($('fieldset').index(current_fs)).removeClass('active');
    previous_fs.show();
    current_fs.animate({
      opacity: 0
    }, {
      step: function(now, mx) {
        scale = 0.8 + (1 - now) * 0.2;
        left = (1 - now) * 50 + '%';
        opacity = 1 - now;
        current_fs.css({
          'left': left
        });
        previous_fs.css({
          'transform': 'scale(' + scale + ')',
          'opacity': opacity
        });
      },
      duration: 800,
      complete: function() {
        current_fs.hide();
        animating = false;
      },
      easing: 'easeInOutBack'
    });
  });

  $('#msform').on('keyup keypress', function(e) {
    var keyCode = e.keyCode || e.which;
    if (keyCode === 13) { 
      e.preventDefault();
      return false;
    }
  });

});
