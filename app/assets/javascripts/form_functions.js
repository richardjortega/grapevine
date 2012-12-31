/* Custom JS */

$(document).ready(function() {
	// /* Google Maps Address Picker */
	// var addresspickerMap = $( "#addresspicker_map" ).addresspicker({
	// 		regionBias: "us",
	// 		mapOptions: {
	// 			zoom: 15,
	// 			center: new google.maps.LatLng(29.4286101, -98.49193479999997)
				
	// 		},
	// 		  elements: {
	// 		    map:      "#map",
	// 		    lat:      "#lat",
	// 		    lng:      "#lng",
	// 		    locality: '#locality',
	// 		    country:  '#country',
	//         type:    '#type' 
	// 		  },
	// 		  draggableMarker: false
	// 	});
	// 	var gmarker = addresspickerMap.addresspicker( "marker");
	// 	gmarker.setVisible(true);
	// 	addresspickerMap.addresspicker( "updatePosition");

	/* Jquery masked plugin */
	$("#user_phone_number").mask("(999) 999-9999");
	$(".zip").mask("99999");

});