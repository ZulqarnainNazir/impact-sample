// $('#checkout-button').click(function(event) {
$(document).on('click', '#checkout-button', function(e) {
  e.preventDefault();
  var url = $(this).data('url');
  var jqxhr = $.ajax({
      url: url,
      type: 'GET',
      // data: '',
      dataType: 'json'
    });
    jqxhr.done(function(response) {
      stripe.redirectToCheckout({
        // Make the id field from the Checkout Session creation API response
        // available to this file, so you can provide it as parameter here
        // instead of the {{CHECKOUT_SESSION_ID}} placeholder.
        sessionId: response.session_id
      }).then(function(result) {
        // If `redirectToCheckout` fails due to a browser or network
        // error, display the localized error message to your customer
        // using `result.error.message`.
        console.log(result.error.message);
      });

    });

});
