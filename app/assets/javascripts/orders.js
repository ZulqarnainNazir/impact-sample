$(document).on('click', '.fulfill-order-clicked', function(e) {
  e.preventDefault();
  var item = $(this);
  var order_id = $(this).attr("data-order-id");
  var business_id = $(this).attr("data-business-id");
  var jqxhr = $.ajax({
    type: 'POST',
    url: '/businesses/' + business_id + '/orders/' + order_id,
    data: { _method: 'put' },
    dataType: 'json'
  });
  jqxhr.done(function(data) {
    console.log("Fulfilled Order Id:" + order_id);
    item.addClass('hidden');
    item.closest('.order-row').find('.js-msg').text('Success!');
    item.closest('.order-row').find('.js-msg').addClass('text-success');
    // For Show page
    item.closest('.order-row').find('.order-status-block').removeClass('text-danger');
    // For index page
    item.closest('.order-row').find('.order-status').removeClass('text-danger');
    item.closest('.order-row').find('.order-status').text('Delivered');


  });
  jqxhr.fail(function(response) {
    console.log("Failed to fulfill order with ID:" + order_id);
    item.closest('.order-row').find('.js-msg').addClass('text-danger');
    item.closest('.order-row').find('.js-msg').text('Something went wrong, try refreshing the page.')
  });

});
