contactFormHelpers = {
  editContactFormSettings: (groupId, block) ->
    $('#contact_form_settings_group_uuid').val groupId
    $('#contact_form_settings_block_uuid').val block.uuid
    if block.settings && block.settings.contact_form_widget_id
      $('#contact_form_embed_id').val(block.settings.contact_form_widget_id)
    $('#contact_form_settings_modal .btn.btn-primary').trigger('click')
    $('#contact_form_settings_modal').modal('show')

  updateContactFormSettings: (component) ->
    component.updateBlock $('#contact_form_settings_group_uuid').val(),
                          $('#contact_form_settings_block_uuid').val(),
                          contact_form_widget_id: $('#contact_form_embed_id').val()
}

window.contactFormHelpers = contactFormHelpers
