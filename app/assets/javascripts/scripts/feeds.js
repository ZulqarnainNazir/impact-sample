$(document).ready(function(){
  $('a.feed-type-info').click(function(){
    swal({
      html: true,
      customClass: 'sweet-alert--left sweet-alert-scroll',
      title: 'Supported Feed Types',
      text: '<div class="sweet-alert_block">' +
          '<p>Currently supported calendars:</p>' +
          '<ul>' +
            '<li>Google Calendar</li>' +
            '<li>Chamber Master</li>' +
            '<li>Chamber Organizer and Chamber Nation</li>' +
            '<li>Timely</li>' +
            '<li>Contact us if your calendar is not included</li>' +
          '</ul>' +
          '<p>Learn more about importing <a href="http://help.locable.com/marketing-tools/how-to-import-from-an-existing-event-calendar", target="_blank">in our support center</a>' +
        '</div>',
      type: 'info'
    });
  });
});
