$(document).ready ->
	$('#yes-button').click (event) ->
		event.preventDefault()
		$('#no_info').hide()
		$('#yes_info').show()
	$('#no-button').click (event) ->
		event.preventDefault()
		$('#yes_info').hide()
		$('#no_info').show()	