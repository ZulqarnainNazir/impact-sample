const linkHelpers = {
  editLink(groupId, block) {
    // const group = this.state.groups[group_uuid];
    // const block = group.blocks[block_uuid];
    $('#link_group_uuid').val(groupId);
    $('#link_block_uuid').val(block.uuid);
    $('#link_id').val(block.link_id);
    $('#link_external_url').val(block.link_external_url && (block.link_external_url.length > 0) ? block.link_external_url : 'http://');
    $('#link_label').val(block.link_label && (block.link_label.length > 0) ? block.link_label : 'Learn More');
    $('#link_no_follow').prop('checked', !!block.link_no_follow);
    $('#link_target_blank').prop('checked', !!block.link_target_blank);
    $('#link_version_none').prop('checked', !(['link_internal', 'link_external'].indexOf(block.link_version) >= 0));
    $('#link_version_internal').prop('checked', block.link_version === 'link_internal');
    $('#link_version_external').prop('checked', block.link_version === 'link_external');
    linkHelpers.toggleLinkOptions();
    $('#link_modal').modal('show');
  },

  updateLink(component) {
    component.updateBlock($('#link_group_uuid').val(), $('#link_block_uuid').val(), {
      link_external_url: $('#link_external_url').val(),
      link_id: $('#link_id').val(),
      link_label: $('#link_label').val(),
      link_no_follow: $('#link_no_follow').prop('checked'),
      link_target_blank: $('#link_target_blank').prop('checked'),
      link_version: $('input[name="link_version"]:checked').val(),
    });
    linkHelpers.resetLink();
  },

  resetLink() {
    $('#link_group_uuid').val('');
    $('#link_block_uuid').val('');
    $('#link_id').val('');
    $('#link_external_url').val('http://');
    $('#link_label').val('Learn More');
    $('#link_no_follow').prop('checked', false);
    $('#link_target_blank').prop('checked', false);
    $('#link_version_none').prop('checked', true);
    linkHelpers.toggleLinkOptions();
  },

  toggleLinkOptions() {
    if ($('#link_version_internal').prop('checked')) {
      $('#link_inputs_default').show();
      $('#link_inputs_internal').show();
      $('#link_inputs_external').hide();
    } else if ($('#link_version_external').prop('checked')) {
      $('#link_inputs_default').show();
      $('#link_inputs_internal').hide();
      $('#link_inputs_external').show();
    } else {
      $('#link_inputs_default').hide();
      $('#link_inputs_internal').hide();
      $('#link_inputs_external').hide();
    }
  },
};

window.linkHelpers = linkHelpers;
