$(document).ready(function(){
  function doPoll() {
    $.get(window.importStatus.pollingPath, function(data) {
      if (data.status == 'Pending') {
        setTimeout(doPoll, 5000);
      } else {
        $('#importing-modal').modal('hide');
        window.importStatus = undefined;
        window.location = data.redirect_path;
      }
    });
  }

  $('.remote-import-form input[type=submit]').click(function(e){
    e.preventDefault();

    $('#importing-modal').modal('show');

    var form = $('.remote-import-form')[0];

    $.ajax({
      type: "POST",
      url: form.action,
      data: $(form).serialize(),
      success: function(response) {
        window.importStatus = {};
        window.importStatus.pollingPath = response.polling_path;

        doPoll();
      }
    });
  })
});
