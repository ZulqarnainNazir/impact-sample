$ = jQuery

copyToClipboard = (text) ->
  window.prompt("Copy to clipboard: Ctrl+C, Enter", text)

ready = ->
  $('#new_pdf').bind("ajax:complete", (data) ->
    console.log(data)
    if(data.currentTarget[1].files[0].type != "application/pdf")
      alert('This uploader only works for PDFs')
    if(data.currentTarget[1].files[0].type == "application/pdf")
      alert("PDF uploaded");
      window.location=data.currentTarget.action;
  );

$(document).ready(ready);
$(document).on('page:load', ready);
