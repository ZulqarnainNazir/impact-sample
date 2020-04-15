$(document).on('click', '.cart-update-button', function(e) {
  e.preventDefault();
  var form = $(this).closest('td').prev().find('form');
  form.submit();
});
