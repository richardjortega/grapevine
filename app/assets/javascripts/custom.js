$(document).ready(function() {

	// sign in form
		$('a.sign-in-link').click(function() {
			event.preventDefault();
			$('.sign-in-form').toggleClass('active');
		});

	// alert time out
		setTimeout(function(){ 
      $(".alert").fadeOut("slow"); 
    }, 1500 ); 

});