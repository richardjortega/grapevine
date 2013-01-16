$(document).ready(function() {

	// sign in form
		$('a.sign-in-link').click(function() {
			$('.sign-in-form').toggleClass('active');
			event.preventDefault();
		});

	// alert time out
		setTimeout(function(){ 
      $(".alert").fadeOut("slow"); 
    }, 1500 ); 

  // twitter call
  $.getJSON("https://api.twitter.com/1/statuses/user_timeline/pickgrapevine.json?count=1&include_rts=1&callback=?", function(data) {
     $("#twitter").html(data[0].text);
});

});