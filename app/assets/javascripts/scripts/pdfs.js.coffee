$ = jQuery

# $ ->
copyToClipboard = (text) ->
  window.prompt("Copy to clipboard: Ctrl+C, Enter", text)


$ ->
  $("#new_pdf").on("ajax:success", (e, data, status, xhr) ->
    console.log("sucessful ajax")
  ).on "ajax:error", (e, xhr, status, error) ->
    console.log("unsucessful ajax")
  $('#new_pdf').bind("ajax:complete", (data) ->
    console.log(data)
  );
