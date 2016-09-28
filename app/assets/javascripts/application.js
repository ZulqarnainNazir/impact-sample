//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.remotipart
//= require turbolinks
//= require react
//= require react_ujs
//= require components
//= require bootstrap-sprockets
//= require bootstrap-select
//= require bootstrap-datepicker
//= require jquery-fileupload/basic
//= require jquery.minicolors
//= require recurring_select
//= require summernote
//= require twitter/typeahead.min
//= require_tree ./plugins
//= require_tree ./scripts
//= require_tree .


Turbolinks.enableProgressBar();

var ready = function() {
  $('.checkbox-toggle input:checked').closest('.checkbox-toggle').addClass('checkbox-toggle-active');
  $('.gallery-images-associations').galleryImagesAssociations();
  $('.lines-associations').linesAssociations();
  $('.menus-sortable').menusSortable();
  $('.openings-associations').openingsAssociations();
  $('.pages-associations').pagesAssociations();
  $('.post-sections-associations').postSectionsAssociations();
  $('.save-once').saveOnce();
  $('.selectpicker').selectpicker();
  $('.webhosts-associations').webhostsAssociations();
  $('.webpage-designer').webpageDesigner();
  $('.wysihtml-editor').wysihtmlEditor();
  $('[data-show-when-checked]').showWhenChecked();
  $('[data-show-when-clicked]').showWhenClicked();
  $('[data-toggle-class-when-clicked]').toggleClassWhenClicked();
  $('[data-toggle="tooltip"]').tooltip();
  $('*[data-toggle=lightbox]').click(function (e) {
    e.preventDefault();
    $(this).ekkoLightbox();
  });

  $(document).on('shown.bs.modal', function (e) {
    var titleInput = $(e.target).find('input[id$=-block-attributes-heading]').get(0) ||
      $(e.target).find('input[type=text]').get(0);

    if (titleInput) {
      $(titleInput).focus();
    }
  });

  $('.checked-highlight input:checked').closest('.checked-highlight').addClass('checked-highlight-active');
  $(document).on('change', '.checked-highlight input', function() {
    $(this).closest('.checked-highlight').toggleClass('checked-highlight-active');
  });
};
$(document).ready(ready)
$(document).on('page:load', ready);
