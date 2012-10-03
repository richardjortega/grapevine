/* Custom JS */

$(document).ready(function() {
	
	//var = addresspicker = $( '.addresspicker' ).addresspicker();
	var addresspickerMap = $( "#addresspicker_map" ).addresspicker({
			regionBias: "us",
			mapOptions: {
				zoom: 15,
				center: new google.maps.LatLng(29.4286101, -98.49193479999997)
				
			},
			  elements: {
			    map:      "#map",
			    lat:      "#lat",
			    lng:      "#lng",
			    locality: '#locality',
			    country:  '#country',
	        type:    '#type' 
			  },
			  draggableMarker: false
		});
		var gmarker = addresspickerMap.addresspicker( "marker");
		gmarker.setVisible(true);
		addresspickerMap.addresspicker( "updatePosition");

		$('#signup-page #map').css('opacity', '0');
		$('input#addresspicker_map').focus(function() {
			$('#signup-page #map').animate({
				opacity: '1'
			}, 700, function() {});
		});
});