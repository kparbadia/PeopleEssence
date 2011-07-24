// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
    $("form[data-remote], a[data-remote]").each(function(i, form){
        var f = $(form).closest(".ajax-container");
        var loading = $("<div class='ajax-indicator'></div>");

        f.append(loading.hide());

        // hide errors and notice and show loading indicator when loading
        f.bind("ajax:before", function(){
            loading.show();
        })

        // hide loading indicator when finished
        f.bind("ajax:complete", function() {
            loading.hide();
        })

        // show notice on success
        f.bind("ajax:success", function(ev, data, status, xhr){
            loading.hide();
        })

        // show errors on failure
        f.bind("ajax:failure", function(ev, xhr, status){

            })
    });
});