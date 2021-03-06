jQuery(document).ready(function($){
    var offset = 1250;
    var duration = 200;

    if ($(document).width() <= 999) {
      $('.alertbar').slideDown(duration); // lets keep it visible if its < 999 px as it will be at the bottom of the screen as per css
    }

    $(window).on('resize', function() {
      if ($(document).width() <= 999) {
        $('.alertbar').slideDown(duration); // lets keep it visible if its < 999 px as it will be at the bottom of the screen as per css
      } else {
        $('.alertbar').slideUp(duration);
      }
    });

    // Smooth scroll to an anchor
    $('a.smoothscroll[href*="#"]')
      // Remove links that don't actually link to anything
      .not('[href="#"]')
      .not('[href="#0"]')
      .click(function(event) {
        // On-page links
        if (
          location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '')
          &&
          location.hostname == this.hostname
        ) {
          // Figure out element to scroll to
          var target = $(this.hash);
          target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
          // Does a scroll target exist?
          if (target.length) {
            // Only prevent default if animation is actually gonna happen
            event.preventDefault();
            $('html, body').animate({
              scrollTop: target.offset().top
            }, 1000, function() {
              // Callback after animation
              // Must change focus!
              var $target = $(target);
              $target.focus();
              if ($target.is(":focus")) { // Checking if the target was focused
                return false;
              } else {
                $target.attr('tabindex','-1'); // Adding tabindex for elements not focusable
                $target.focus(); // Set focus again
              };
            });
          }
        }
      });
    
    // Hide Header on on scroll down
    var didScroll = true; // since using html fragments of categories & tags pages are not triggering `scroll()` even though page is shown in scrolled condition, lets just force an explcit check on load
    var lastScrollTop = 0;
    var delta = 5;
    var navbarHeight = $('nav').outerHeight();

    $(window).scroll(function(event){
        didScroll = true;
    });

    setInterval(function() {
        if (didScroll) {
            hasScrolled();
            didScroll = false;
        }
    }, 250);

    function hasScrolled() {
        var st = $(this).scrollTop();
        var brandrow = $('.brandrow').css("height");
        var canSubscribeBarVisiblityChange = $(document).width() > 999;

        // Make sure they scroll more than delta
        if(Math.abs(lastScrollTop - st) <= delta)
            return;

        // If they scrolled down and are past the navbar, add class .nav-up.
        // This is necessary so you never see what is "behind" the navbar.
        if (st > lastScrollTop) {
            // Scroll Down
            if (canSubscribeBarVisiblityChange) {
              $('.alertbar').slideUp(duration);
            }
            // hide navbar only if scrolling is past navbar height
            if (st > navbarHeight) {
              $('nav').removeClass('nav-down').addClass('nav-up');
              $('.nav-up').css('top', - $('nav').outerHeight() + 'px');
            }
        } else {
            // Scroll Up
            if (canSubscribeBarVisiblityChange) {
                $('.alertbar').slideDown(duration);
            }
            if(st + $(window).height() < $(document).height()) {
                $('nav').removeClass('nav-up').addClass('nav-down');
                $('.nav-up, .nav-down').css('top', '0px');
            }
        }

        lastScrollTop = st;
    }

    $('.site-content').css('margin-top', $('header').outerHeight() + 'px');
});
