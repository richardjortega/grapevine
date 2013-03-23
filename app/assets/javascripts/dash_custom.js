// dash custom js
$(document).ready(function() {
$('.show-popover').popover({ trigger: "hover" });


var lineChartW = $('#last_two_weeks_reviews_line_chart').width();
var lineCharts = $('[id*=_line_chart]');

var pieChartW = $('#last_two_weeks_reviews_pie_chart').width();
var pieCharts = $('[id*=_pie_chart]');

$(lineCharts).width(lineChartW);
$(pieCharts).width(pieChartW);

});



