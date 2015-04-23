//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require turbolinks
//= require react
//= require react_ujs
//= require components
//= require bootstrap-sprockets
//= require bootstrap-select
//= require jquery-fileupload/basic
//= require jquery.minicolors
//= require bootstrap-wysihtml5
//= require_tree ./plugins
//= require_tree ./scripts

Turbolinks.enableProgressBar();

var ready = function() {
  window['rangy'].initialized = false;
  $('.checkbox-toggle input:checked').closest('.checkbox-toggle').addClass('checkbox-toggle-active');
  $('.gallery-images-associations').galleryImagesAssociations();
  $('.openings-associations').openingsAssociations();
  $('.menus-sortable').menusSortable();
  $('.pages-associations').pagesAssociations();
  $('.project-images-associations').projectImagesAssociations();
  $('.webhosts-associations').webhostsAssociations();
  $('.webpage-designer').webpageDesigner();
  $('.wysihtml-editor').wysihtmlEditor();
  $('*[data-toggle=lightbox]').click(function(e) {
    e.preventDefault();
    $(this).ekkoLightbox();
  });
};

$(document).on('ready page:load', ready);
