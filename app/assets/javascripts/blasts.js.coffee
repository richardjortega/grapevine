$(document).ready ->
	$('#yes-button').click (event) ->
		event.preventDefault()
		$('#no_info').hide()
		$('#yes_info').fadeIn()
	$('#no-button').click (event) ->
		event.preventDefault()
		$('#yes_info').hide()
		$('#no_info').fadeIn()	