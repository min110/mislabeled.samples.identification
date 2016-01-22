/**
 * @file
 * JCore theme behaviors.
 */

(function ($) {

  Drupal.behaviors.hwJcore1ThemeScripts = {
    attach: function(context, settings) {
      // Give the login form some love.
      $('#user-login-form .login-submit-link', context).click(function () {
        $('#user-login-form').submit();
        return false;
      });
      
      $('#region-menu .nice-menu > .menuparent > a, .parent-link-disabled .nice-menu > .menuparent > a', context).click(function (event) {
        event.preventDefault();
      });

      // Search icon cross-browser click handler.
      $('#highwire-search-form .form-item-txtsimple .form-text + .icon-search, [id^="search-block-form"] .form-item-search-block-form .form-text + .icon-search, .highwire-quicksearch .button-wrapper.button-mini, .highwire-quicksearch .button-wrapper .icon-search', context).click(function () {
         $(this).parents('form:first').submit();
      });

      // Disable :focus styles on mouse clicks but retain them on keyboard entry
      $("a").on("mousedown", function(e) {
        $(this).focus(function() {
          $(this).blur();
          $(this).hideFocus=true; //IE
        });
      });
    }
  };
  Drupal.theme.jCarouselButton = function(type) {
    // Add text for buttons for accessibility.
    if(type == 'previous') {
      var linkText = "Previous Slide";
    } else if (type == 'next') {
      var linkText = "Next Slide";
    }
    return '<a href="javascript:void(0)"><span class="element-invisible">' + linkText + '</span></a>';
  };
})(jQuery);
;
