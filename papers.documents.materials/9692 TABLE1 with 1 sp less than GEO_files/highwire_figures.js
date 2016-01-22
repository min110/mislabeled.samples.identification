/**
 * Highwire Figure
 *
 * Copyright (c) HighWire Press, Inc.
 * This software is open-source licensed under the GNU Public License Version 2 or later
 * The full license is available in the LICENSE.TXT file at the root of this repository
 */
(function ($) {
  Drupal.behaviors.highwireFiguresMarkupProcessor = {
    attach: function(context, settings) {
      /**
       * Force hide captions for mobile. Can't do this directly with CSS only since ColorboxJS controls visibility.
       */
      $('body').bind('highwireResponsiveLayoutTransition', function(e, d) {
        if(d.from != d.to) {
          if (d.to == 'mobile') {
            // .force-hide is display:none !important. See jcore_1/css/global.css
            $('#cboxTitle').addClass('force-hide');
          }
          else {
            $('#cboxTitle').removeClass('force-hide');          
          }
        }
        else if (d.to == 'mobile') {
          $('#cboxTitle').addClass('force-hide'); 
        }
      });

      $('a.fragment-images.colorbox-load', context).once('highwireFiguresMarkupProcessor', function() {
        $(this, context).each(function() {
          var figTitle = false;

          figTitle = $(this).data('figure-caption');
          // This check will ensure for table fragment will not cause
          // any data attribute error.
          if (figTitle != undefined) {
            figTitle = $.parseHTML(figTitle);
            figTitle = $(figTitle).text();;
          }
          else {
            figTitle = false;
          }

          // Disable image preloading - this messes with our logging.
          cbsettings = $.extend(settings.colorbox, {'preloading': false, title: function(){
            return figTitle;
          }});

          $(this).colorbox(cbsettings);
        });
      });
    }
  };
})(jQuery);
