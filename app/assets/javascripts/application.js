//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery-ui
//= require match-media/media.match.min
//= require turbolinks
//= require js.cookie
//= require jstz
//= require browser_timezone_rails/set_time_zone
//= require react
//= require ./vendor/react-router-v3.0.2
//= require ./vendor/store-v1.3.20
//= require react_ujs
//= require components
//= require bootstrap-sprockets
//= require bootstrap-select
//= require bootstrap-datepicker
//= require jquery-fileupload/basic
//= require jquery.minicolors
//= require recurring_select
//= require summernote
//= require moment
//= require bootstrap-datetimepicker
//= require twitter/typeahead.min
//= require dashboard/inspinia.js
//= require_tree ./plugins
//= require_tree ./scripts
//= require_tree .
//= stub plugins/iframeResizer.contentWindow.min.js

Turbolinks.enableProgressBar();

var ready = function() {
  $('.checkbox-toggle input:checked').closest('.checkbox-toggle').addClass('checkbox-toggle-active');
  $('.gallery-images-associations').galleryImagesAssociations();
  $('.lines-associations').linesAssociations();
  $('.menus-sortable').menusSortable();
  $('.openings-associations').openingsAssociations();
  $('.pages-associations').pagesAssociations();
  $('.post-sections-associations').postSectionsAssociations();
  $('.company-list-categories-associations').CompanyListCategoriesAssociations();
  $('.contact-form-form-fields-associations').ContactFormFormFieldsAssociations();
  //$('.save-once').saveOnce();
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

  $("#products_search input").keyup(function() {
    $.get($("#products_search").attr("action"), $("#products_search").serialize(), null, "script");
      return false;
  });

  // When the viewport is narrow enough, we collapse the #contact-more-collapse & #company-more-collapse element.
  if (matchMedia('(max-width: 768px)').matches) {
    $('.contact-view-more').addClass('collapsed').attr('aria-expanded', 'false');
    $('#contact-more-collapse').removeClass('in').attr('aria-expanded', 'false');
    $('.company-view-more').addClass('collapsed').attr('aria-expanded', 'false');
    $('#company-more-collapse').removeClass('in').attr('aria-expanded', 'false');
  }
};

$(document).ready(ready)
$(document).on('page:visit', ready);
