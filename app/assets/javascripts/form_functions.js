/* Custom JS */

$(document).ready(function() {
	/* Jquery masked plugin */
	$("#user_phone_number").mask("(999) 999-9999");
	$("#user_locations_attributes_0_zip").mask("99999");

	// jquery validate contact form
	$(".contact-form, #payment-form").validate();

});