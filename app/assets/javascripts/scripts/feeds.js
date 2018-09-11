$(document).ready(function(){
  $('a.feed-type-info').click(function(){
    swal({
      html: true,
      customClass: 'sweet-alert--left',
      title: 'These are feed types we support',
      text: '<div class="sweet-alert_block">' +
          '<strong>Chamber Master</strong> or ' +
          '<strong>Chamber Organizer</strong>' +
          '<br/>' +
          '<p>The correct feed URL for this type of input will include "rss" and link to an XML document.</p>' +
        '</div>' +
        '<div class="sweet-alert_block">' +
          '<strong>Timely</strong>' +
          '<br/>' +
          '<p>To import a Timely calendar:' +
          '<ul>' +
            '<li>Find the "Subscribe" menu</li>' +
            '<li>Hover over the "Export to XML" option</li>' +
            '<li>Right click and choose "Copy Link Address." This is the URL we need in order to import the calendar.</li>' +
          '</ul>' +
        '</div>' +
        '<div class="sweet-alert_block">' +
          '<strong>Google Calendar</strong>' +
          '<br/>' +
          '<p>To import a Google calendar:</p>' +
          '<ul>' +
            '<li><a href="https://calendar.google.com/calendar/r", target="_blank">Click this link</a> to go to your Google calendars</li>' +
            '<li>Click the gear icon in the top right, choose "Settings"</li>' +
            '<li>Look for the calendar you want to import underneath "Settings for my calendars", click it</li>' +
            '<li>Find the URL underneath "Public address in iCal format." This is the URL we need in order to import the calendar.</li>' +
          '</ul>' +
        '</div>',
      type: 'info'
    });
  });
});
