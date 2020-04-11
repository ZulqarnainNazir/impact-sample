$(document).on('click', '.archive-product-button-clicked', function(e) {
  e.preventDefault();
  var item = $(this);
  var product_id = $(this).attr("data-product-id");
  var business_id = $(this).attr("data-business-id");
  var new_status = $(this).attr("data-new-product-status");

  console.log(new_status);

  var jqxhr = $.ajax({
    type: 'POST',
    url: '/businesses/' + business_id + '/products/' + product_id,
    data: { _method: 'put', status: new_status },
    dataType: 'json'
  });
  jqxhr.done(function(data) {
    if (new_status == 'archived') {
      console.log("Archived Product Id:" + product_id);
      item.text("Un-Archive");
      item.closest('.product-row').find('.product-status').text('Archived');
      item.attr('data-new-product-status', 'active');
    } else if (new_status == 'active') {
      console.log("Un-Archived Product Id:" + product_id);
      item.text("Archive");
      item.closest('.product-row').find('.product-status').text('Active');
      item.attr('data-new-product-status', 'archived');
    }

    item.closest('.product-row').find('.js-msg').addClass('text-success');
    item.closest('.product-row').find('.js-msg').text('Success!');

    // item.addClass('hidden');
    // item.closest('.order-row').find('.js-msg').text('Success!');
    // item.closest('.order-row').find('.js-msg').addClass('text-success');
    // // For Show page
    // item.closest('.order-row').find('.order-status-block').removeClass('text-danger');
    // // For index page
    // item.closest('.order-row').find('.order-status').removeClass('text-danger');
    // item.closest('.order-row').find('.order-status').text('Delivered');


  });
  jqxhr.fail(function(response) {
    console.log("Failed to Update Product with ID:" + product_id);
    item.closest('.product-row').find('.js-msg').addClass('text-danger');
    item.closest('.product-row').find('.js-msg').text('Something went wrong, try refreshing the page.')
  });

});
