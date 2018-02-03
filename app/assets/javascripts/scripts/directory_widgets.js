var toggleDescriptionText = function(businessID) {
  $(".full-description-" + businessID).hide();
  $('.js-view-less').click(function(e) {
    e.preventDefault();
    $(".full-description-" + businessID).hide();
    $(".short-description-" + businessID).show();
  });
  $('.js-read-more').click(function(e) {
    e.preventDefault();
    $(".full-description-" + businessID).show();
    $(".short-description-" + businessID).hide();
  });
}

window.initDirectoryModalHandler = function(businessID, url) {
  $(".modal-body").html('<div class="text-center">' +
                          '<i class="fa fa-spinner fa-spin fa-3x fa-fw"></i>' +
                        '</div>');

  $.get(url, function(response) {
    var body = $('<div/>').append(response).find('.row')[0];

    $("#business-modal-" + businessID + " .modal-body").html(body);

    toggleDescriptionText(businessID);
  });
};
