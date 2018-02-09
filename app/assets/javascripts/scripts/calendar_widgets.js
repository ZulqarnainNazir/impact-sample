$('.calendar-card').click(function(event) {
  event.preventDefault();
  var target = $(event.target);
  var card = target.parents('.calendar-card');

  var slug = target.data('slug');
  if (!slug) { slug = card.data('slug'); }

  window.location.hash = slug;
});

$('.calendar-modal').on('click', function(event) {
  if ($(event.target).data('dismiss') === 'modal') {
    event.preventDefault();
    window.location.hash = "";
  }
});