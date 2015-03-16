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
  $('.webhosts-associations').webhostsAssociations();
};

$(document).ready(ready);
$(document).on('page:load', ready);
