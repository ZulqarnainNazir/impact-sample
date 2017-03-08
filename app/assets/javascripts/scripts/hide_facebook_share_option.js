//= require moment

$(document).ready(function() {
	// check when clicking off or on timepicker and when visiting page for first time
    // checkTime();
	$('#datetimepicker').click(function(){
		checkTime();
	});
	
	$('body').click(function(){
		checkTime();
	});
});

function checkTime() {
    // get datetime text from form input ie "Oct 25 2016 10:27 AM -0700"
    if ($('#datetimepicker').children()[0] && $('.fbshare input')[0]) {
        var dt = $('#datetimepicker').children()[0];

        var then = moment(dt.value).format('MMM D YYYY h:mm A ZZ');
        now = moment().format('MMM D YYYY h:mm A ZZ')


        if (moment(moment(then).toISOString()).isAfter(moment(now).toISOString())) {
            // datetime is later than now
            // do disable and gray out checkbox
            $('.fbshare input')[0].disabled = true;
            var label = $('.fbshare label')[0];
            $(label).css("opacity", 0.5)
        } else {
            // datetime is now or old
            // don't gray out share to fb
            $('.fbshare input')[0].disabled = false;
            var label = $('.fbshare label')[0];
            $(label).css("opacity", 1)
        }
    }
}
