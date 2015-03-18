//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require turbolinks
//= require react
//= require react_ujs
//= require components
//= require bootstrap-sprockets
//= require jquery-fileupload/basic
//= require_tree ./scripts

Turbolinks.enableProgressBar();

var ready = function() {
  $('.checkbox-toggle input:checked').closest('.checkbox-toggle').addClass('checkbox-toggle-active')
  $('.openings-associations').openingsAssociations();
  $('.webhosts-associations').webhostsAssociations();
};

$(document).ready(ready);
$(document).on('page:load', ready);
