$(document).on('change', '.community_selector', function(e) {
  var tag = $(this)
  // alert(tag.find(":selected").val());
  tag.prop('disabled', true);
  tag.after($('<i class="fa fa-spin fa-spinner float-right"></i>'));
  var jqxhr = $.ajax({
    url: '/super/business_data/update_community',
    type: 'PUT',
    data: { community_id: tag.find(":selected").val() },
    dataType: 'json'
  });
  jqxhr.done(function(data) {
    tag.next().removeClass('fa-spin').removeClass('fa-spinner').addClass('fa-thumbs-up');
    tag.prop('disabled', false);
  });
  jqxhr.fail(function(response) {
    tag.next().removeClass('fa-spin').removeClass('fa-spinner').addClass('fa-exclamation-triangle');
    tag.prop('disabled', false);
  });
});


// $(document).on('change', 'form.admin_businesses__site_select select', function(e) {
//   var form = $(this).closest('form');
//   form.find('select').prop('disabled', true);
//   form.find('i').remove();
//   form.append($('<i class="fas fa-spin fa-spinner"></i>'));
//   var jqxhr = $.ajax({
//     url: form.attr('action'),
//     type: 'PUT',
//     data: { site_id: form.find('select').prop('value') },
//     dataType: 'json'
//   });
//   jqxhr.done(function(data) {
//     form.find('i').removeClass('fa-spin').removeClass('fa-spinner').addClass('fa-thumbs-up');
//     form.find('select').prop('disabled', false);
//   });
//   jqxhr.fail(function(response) {
//     form.find('i').removeClass('fa-spin').removeClass('fa-spinner').addClass('fa-exclamation-triangle');
//     form.find('select').prop('disabled', false);
//   });
// });
