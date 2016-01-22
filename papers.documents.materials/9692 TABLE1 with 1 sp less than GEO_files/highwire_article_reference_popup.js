/**
 * Highwire Article References pop up
 *
 * Copyright (c) 2010-2011 Board of Trustees, Leland Stanford Jr. University
 * This software is open-source licensed under the GNU Public License Version 2 or later
 * The full license is available in the LICENSE.TXT file at the root of this repository
 */
(function ($) {
  Drupal.behaviors.articleRefPopup = {
    attach: function(context, settings) {
      $('a.xref-bibr, a.xref-ref', context).once('article-ref-popup', function() {

        if( $('a' + $(this).attr('href')).length )  {
          $(this).attr('rel', $(this).attr('href') + "~.ref-cit");

          $(this).cluetip({
            onActivate: function(event) {
              // Disable for mobile
              var activate = true;
              if (Drupal.highwireResponsive) {
                var currentLayout = Drupal.highwireResponsive.getCurrentLayout();
                activate = currentLayout !== 'mobile' ? true : false;
              }
              return activate;
            },
            local: true,
            showTitle: false,
            width: '650px',
            hideLocal: false,
            sticky: true,
            mouseOutClose: 'both',
            closePosition: 'none',
            dropShadow: false,
            cluetipClass: 'article-ref-popup'
          });
        }
        else {
          $(this).addClass( "hw-no-refrence");
        }

      });
    }
  };
})(jQuery);
