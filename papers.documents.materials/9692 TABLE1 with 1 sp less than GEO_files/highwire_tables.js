/**
 * Highwire AT Symbol
 *
 * Copyright (c) 2010-2011 Board of Trustees, Leland Stanford Jr. University
 * This software is open-source licensed under the GNU Public License Version 2 or later
 * The full license is available in the LICENSE.TXT file at the root of this repository
 */
(function ($) {
  Drupal.behaviors.highwireTablesMarkupProcessor = {
    attach: function(context, settings) {
      $('a.table-expand-inline', context).once('highwireTablesMarkupProcessor', function() {
        $(this, context).each(function() {
          var $caption, captionHTML;
          var self = this;
          var toggle = true;

          // find the tables those does not have captions :)
          $(self, context).each(function(){
            var $caption_temp;
            $caption_temp = $(self).closest('.table');

            if($caption_temp.find('.table-caption').length == 0) {
              $caption_temp.append( "<div class='table-caption'> &nbsp;</div>" );
              Drupal.attachBehaviors($caption_temp[0]);
            }
          });

          $(self).click(function(event) {
            event.preventDefault();
            if (toggle) {
              toggle = false;
              $(self).closest('.table').addClass('table-expand-inline');
              $caption = $(self).closest('.table').find('.table-caption');
              captionHTML = $caption.html();
              $caption.load($(this).data('table-url'), function () {
                $(self).html('Collapse inline');
                $(self).closest('.table').find('table').wrap('<div class="table-wrapper"></div>');  // #JCORE-1937
                Drupal.attachBehaviors($caption[0]);
                var alt = $(self).closest('.table').find('.table-label').text();
                $(self).closest('.table').find('table').attr('alt', alt);
              });
            }
            else {
              $(self).closest('.table').removeClass('table-expand-inline');
              $caption.html(captionHTML);
              toggle = true;
              $(self).html('View inline');
            }
          });
        });
        /**
         * Added this colorbox calling function as AJAX tabs naigation holds
         * poping up data into model
         */
        $('a.table-expand-popup', context).each(function() {
          cbsettings = $.extend(settings.colorbox, {title: false});
          $(this).colorbox(cbsettings);
        });
      });
    }
  };

  // Attach drupal behaviors to colorbox loading
  $(document).bind('cbox_complete', function() {
    if (colorbox) {
      Drupal.attachBehaviors($(colorbox)[0]);
    }
  });
})(jQuery);
