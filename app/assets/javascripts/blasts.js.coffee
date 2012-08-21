$(document).ready ->
	$('#yes-button').click (event) ->
		$('#no_info').hide()
		$('#yes_info').fadeIn()
	$('#no-button').click (event) ->
		$('#yes_info').hide()
		$('#no_info').fadeIn()	