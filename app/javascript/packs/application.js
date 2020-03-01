// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
require("@rails/activestorage").start();
import $ from 'jquery';

//= require moment
//= require bootstrap-datetimepicker

window.hideWidget = function(widgetId) {
    $(`#widget_${widgetId}`).fadeOut();
};

$(function () {
    $("#check_email").on("click", function(event) {
        event.preventDefault();
        var val = $("#email").val();

        $.get('/users/check_email', { email: val }, function(data) {
            if (data['available']) {
                document.getElementById("email").classList.add('available')
            } else {
                document.getElementById("email").classList.add('forbidden');
            }
        });
    });
});


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
