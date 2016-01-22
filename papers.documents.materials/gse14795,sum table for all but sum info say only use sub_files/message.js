// requires jquery cookie plugin: $common/scripts/jquery/plugins/cookie.js
// this code enables persistent messages to retain state across pages/sessions
(function($) {
	$(document).ready(function () {
		// flag to let everything know we have javascript enabled
		$("body:not('.js-enabled')").addClass("js-enabled");
		
		$(".visible.global-message .persistent").text("Minimise this message");
		$(".minimised.global-message .persistent").html("Find out more<span class='hidden'> about this message</span>");
		
		// message currently visible
		$(".visible.global-message .persistent").toggle(function() {
			hideMessage();
			$(".message-control").fadeIn("slow");
			return false;
		}, function() {
			showMessage();
			$(".message-control").fadeIn("slow");
			return false;
		});
		
		// message already minimised
		$(".minimised.global-message .persistent").toggle(function() {
			showMessage();
			$(".message-control").fadeIn("slow");
			return false;}
		, function() {
			hideMessage();
			$(".message-control").fadeIn("slow");
			return false;
		});
		$(".minimised.global-message .content h1").clone().insertAfter(".global-message .content").addClass("minimised");	
		
		function hideMessage() {
			$(".message-control").hide();
			$.cookie('minimised', 'true', { expires: 10, path: '/' }); // enables message to retain state across pages/sessions
			$(".global-message .content").slideUp('slow', function() {
				$(".global-message").removeClass("visible");
				$(".global-message").addClass("minimised");
				$(".message-control a.remove").show();
				$(".global-message .content h1").clone().insertAfter(".global-message .content").addClass("minimised");
			});
			$(".message-control a.persistent").html("Find out more<span class='hidden'> about this message</span>");
		}

		function showMessage() {
			$(".message-control").hide();
			$.cookie('minimised', 'false', { expires: 10, path: '/' }); // enables message to retain state across pages/sessions
			$(".global-message h1.minimised").remove();
			$(".global-message .content").slideDown('slow');
			$(".message-control a.persistent").text("Minimise this message");
			$(".global-message").removeClass("minimised");
			$(".global-message").addClass("visible");
		}
		
		
		$(".global-message .action a").click(function() {
			$.cookie('message-global', 'remove', { expires: 30, path: '/' });
		});
		
		$(".global-message .h1 a").click(function() {
			$.cookie('message-global', 'remove', { expires: 30, path: '/' });
		});
		
	});
}) (jQuery);