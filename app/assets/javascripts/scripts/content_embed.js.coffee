$ ->
  categorySelect = $('#content_feed_widget_content_category_ids')
  tagSelect = $('#content_feed_widget_content_tag_ids')
  listSelect = $('#content_feed_widget_company_list_ids')

  checkListSelect = ->
    if listSelect.val() and listSelect.val().length > 0
      categorySelect.prop('disabled', true).trigger("chosen:updated");
      tagSelect.prop('disabled', true).trigger("chosen:updated");
    else
      categorySelect.prop('disabled', false).trigger("chosen:updated");
      tagSelect.prop('disabled', false).trigger("chosen:updated");

  listSelect.change ->
    checkListSelect()

  checkListSelect()
