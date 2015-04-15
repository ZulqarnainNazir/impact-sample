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
  $('.checkbox-toggle input:checked').closest('.checkbox-toggle').addClass('checkbox-toggle-active')
  $('.openings-associations').openingsAssociations();
  $('.menus-sortable').menusSortable();
  $('.pages-associations').pagesAssociations();
  $('.webhosts-associations').webhostsAssociations();
  $('.webpage-designer').webpageDesigner();
  $('.wysihtml-editor').wysihtmlEditor();
};

$(document).ready(ready);
$(document).on('page:load', ready);

$(document).on('page:load', function() {
  window['rangy'].initialized = false;
});
