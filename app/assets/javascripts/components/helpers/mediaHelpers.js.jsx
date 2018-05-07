const mediaHelpers = {
  editMedia(component, type, block, group) {
    $('#media_type').val(type);
    $('#media_group_uuid').val(group.uuid);
    let placement = {};
    if (block) {
      $('#media_block_uuid').val(block.uuid);
      if (type === 'image' &&
          block.block_image_placement &&
          block.block_image_placement.destroy !== '1') {
        placement = block.block_image_placement;
      } else if (type === 'background' &&
        block.block_background_placement &&
        block.block_background_placement !== '1') {
        placement = block.block_background_placement;
      }
    } else {
      if (type === 'group_image' &&
        group.group_image_placement &&
        group.group_image_placement.destroy !== '1') {
        placement = group.group_image_placement;
      } else if (type === 'group_background' &&
        group.group_background_placement &&
        group.group_background_placement !== '1') {
        placement = group.group_background_placement;
      }
    }
    const stateChanges = {
      mediaID: placement.id,
      mediaDestroy: undefined,
      mediaImageAttachmentContentType: placement.image_attachment_content_type,
      mediaImageAttachmentFileName: placement.image_attachment_file_name,
      mediaImageAttachmentFileSize: placement.image_attachment_file_size,
      mediaImageProgress: 0,
      mediaImageStatus: Object.keys(placement).length > 0 ? 'attached' : 'empty',
      mediaImageAttachmentURL: placement.image_attachment_url,
      mediaImageAttachmentCacheURL: undefined,
      mediaImageAttachmentThumbnailURL: placement.image_attachment_thumbnail_url,
      mediaImageAttachmentSmallURL: placement.image_attachment_small_url,
      mediaImageAttachmentSmallFixedURL: placement.image_attachment_small_fixed_url,
      mediaImageAttachmentMediumURL: placement.image_attachment_medium_url,
      mediaImageAttachmentMediumFixedURL: placement.image_attachment_medium_fixed_url,
      mediaImageAttachmentLargeURL: placement.image_attachment_large_url,
      mediaImageAttachmentLargeFixedURL: placement.image_attachment_large_fixed_url,
      mediaImageAttachmentJumboURL: placement.image_attachment_jumbo_url,
      mediaImageAttachmentJumboFixedURL: placement.image_attachment_jumbo_fixed_url,
      mediaLibraryImages: [],
      mediaLibraryLoaded: false,
      mediaLibraryLoadedAll: false,
      mediaLibraryPage: 1,
    };
    // sets the passed in component's state to the above values for media
    // uploading & editing purposes
    component.setState(stateChanges, () => {
      if (type === 'image') {
        $('a[href="#media_tab_embed"]').show();
      } else {
        $('a[href="#media_tab_embed"]').hide();
      }
      if (placement.kind === 'embeds') {
        $('a[href="#media_tab_embed"]').tab('show');
      } else {
        $('a[href="#media_tab_image"]').tab('show');
      }
      $('#media_embed').val(placement.embed);
      $('#media_full_width').prop('checked', placement.full_width || false);
      $('#media_image_alt').val(placement.image_alt);
      $('#media_image_title').val(placement.image_title);
      $('#media_tabs').css('display', 'block');
      $('#media_library').css('display', 'none');
      $('#media_modal').modal('show');
    });
    mediaHelpers.initializeMediaUpload(component);
  },

  initializeMediaUpload(component) {
    $('#media_modal').fileupload({
      dataType: 'XML',
      url: component.props.presignedPost.url,
      formData: component.props.presignedPost.fields,
      paramName: 'file',
      dropZone: '.media_dropzone',
      add: mediaHelpers.mediaUploadAdd.bind(null, component),
      progress: mediaHelpers.mediaUploadProgress.bind(null, component),
      done: mediaHelpers.mediaUploadDone.bind(null, component),
      fail: mediaHelpers.mediaUploadFail.bind(null, component),
    });
  },

  mediaUploadAdd(component, event, data) {
    const file = data.files[0];
    const reader = new FileReader();
    reader.onload = mediaHelpers.mediaUploadRead.bind(null, component, file);
    reader.readAsDataURL(file);
    const formData = component.props.presignedPost.fields;
    formData['Content-Type'] = file.type;
    data.formData = formData;
    data.submit().then((stuff) => { console.log(stuff); });
    console.log(data);
  },

  mediaUploadRead(component, file, event) {
    // console.log(event.target, file);
    // const group = component.state.groups[$('#media_group_uuid').val()];
    // const block = group.blocks[$('#media_block_uuid')];
    if (file.type.match(/^image/) && file.size <= 10000000) {
      component.setState({
        mediaDestroy: undefined,
        mediaImageAttachmentCacheURL: event.target.result,
        mediaImageAttachmentContentType: file.type,
        mediaImageAttachmentFileName: file.name,
        mediaImageAttachmentFileSize: file.size,
        mediaImageAttachmentJumboURL: undefined,
        mediaImageAttachmentJumboFixedURL: undefined,
        mediaImageAttachmentLargeURL: undefined,
        mediaImageAttachmentLargeFixedURL: undefined,
        mediaImageAttachmentMediumURL: undefined,
        mediaImageAttachmentMediumFixedURL: undefined,
        mediaImageAttachmentSmallURL: undefined,
        mediaImageAttachmentSmallFixedURL: undefined,
        mediaImageAttachmentThumbnailURL: undefined,
        mediaImageAttachmentURL: event.target.result,
        mediaImageID: undefined,
        mediaImageStatus: 'uploading',
        mediaImageTitle: '',
      });
    } else {
      component.setState({
        mediaImageStatus: ((component.state.mediaImageAttachmentURL && component.state.mediaImageAttachmentURL.length > 0) || (component.state.mediaImageAttachmentURL && component.state.mediaImageAttachmentURL.length > 0)) ? 'attached' : 'empty',
      });
      alert('Only PNG, JPG and GIF images under 10 megabytes are allowed.');
    }
  },

  mediaUploadProgress(component, event, data) {
    if (component.state.mediaImageStatus === 'uploading') {
      component.setState({
        mediaImageProgress: parseInt((data.loaded / data.total) * 100, 10),
      });
    }
  },

  mediaUploadDone(component, event, data) {
    // console.log(event.target, data);
    if (component.state.mediaImageStatus === 'uploading') {
      component.setState({
        mediaImageAttachmentCacheURL: `//${component.props.presignedPost.host}/${$(data.jqXHR.responseXML).find('Key').text()}`,
        mediaImageStatus: 'finishing',
        localImages: [
          {
            attachment_cache_url: `//${component.props.presignedPost.host}/${$(data.jqXHR.responseXML).find('Key').text()}`,
            attachment_content_type: component.state.mediaImageAttachmentContentType,
            attachment_file_name: component.state.mediaImageAttachmentFileName,
            attachment_file_size: component.state.mediaImageAttachmentFileSize,
            attachment_url: component.state.mediaImageAttachmentURL,
            attachment_thumbnail_url: component.state.mediaImageAttachmentURL,
          },
          ...component.state.localImages,
        ],
      });
      setTimeout(mediaHelpers.mediaUploadFinish.bind(null, component, data), 500);
    }
  },
  mediaUploadFinish(component, data) {
    // console.log(data);
    $('#media_modal').fileupload('destroy');
    const attributes = {
      mediaImageProgress: 0,
      mediaImageStatus: 'attached',
    };
    component.setState(attributes, undefined);
  },

  mediaUploadFail(component, event) {
    if (component.state.mediaImageStatus === 'uploading') {
      component.setState({ mediaImageStatus: 'failed' });
    }
  },

  showMediaLibrary(loadMediaCallback) {
    $('#media_tabs').css('display', 'none');
    $('#media_library').css('display', 'block');
    loadMediaCallback();
  },

  selectMediaLibraryImage(component, image) {
    const changes = {
      mediaImageAttachmentCacheURL: (
        component.state.localImages.indexOf(image) !== -1 ?
        image.attachment_cache_url :
        undefined
      ),
      mediaImageAttachmentContentType: image.attachment_content_type,
      mediaImageAttachmentFileName: image.attachment_file_name,
      mediaImageAttachmentFileSize: image.attachment_file_size,
      mediaImageAttachmentURL: image.attachment_url || image.attachment_thumbnail_url,
      mediaImageAttachmentThumbnailURL: image.attachment_thumbnail_url,
      mediaImageAttachmentSmallURL: image.attachment_small_url,
      mediaImageAttachmentSmallFixedURL: image.attachment_small_fixed_url,
      mediaImageAttachmentMediumURL: image.attachment_medium_url,
      mediaImageAttachmentMediumFixedURL: image.attachment_medium_fixed_url,
      mediaImageAttachmentLargeURL: image.attachment_large_url,
      mediaImageAttachmentLargeFixedURL: image.attachment_large_fixed_url,
      mediaImageAttachmentJumboURL: image.attachment_jumbo_url,
      mediaImageAttachmentJumboFixedURL: image.attachment_jumbo_fixed_url,
      mediaImageID: image.id,
      mediaImageStatus: 'attached',
    };
    component.setState(changes, mediaHelpers.hideMediaLibrary, () => {
      $('#media_image_alt').val(image.alt);
      $('#media_image_title').val(image.title);
    });
  },

  hideMediaLibrary(event) {
    if (event) { event.preventDefault(); }
    $('#media_tabs').css('display', 'block');
    $('#media_library').css('display', 'none');
  },

  resetMedia(component) {
    const stateChanges = {
      mediaDestroy: undefined,
      mediaImageAttachmentContentType: undefined,
      mediaImageAttachmentFileName: undefined,
      mediaImageAttachmentFileSize: undefined,
      mediaImageAttachmentURL: undefined,
      mediaImageProgress: 0,
      mediaImageStatus: 'empty',
      mediaImageTitle: undefined,
      mediaKind: 'images',
      mediaLibraryImages: [],
      mediaLibraryLoaded: false,
      mediaLibraryLoadedAll: false,
      mediaLibraryPage: 1,
    };
    component.setState(stateChanges, () => {
      $('#media_embed').val('');
      $('#media_full_width').prop('checked', false);
      $('#media_image_alt').val('');
      $('#media_image_title').val('');
      $('a[href="#media_tab_image"]').tab('show');
      $('#media_tabs').css('display', 'block');
      $('#media_library').css('display', 'none');
    });
  },

  updateMedia(component /* , blockToUpdate */) {
    const placement_type = $('#media_type').val() === 'image' ? 'block_image_placement' : $('#media_type').val() === 'background' ? 'block_background_placement' : 'group_background_placement';
    const changes = {
      [placement_type]: {
        id: component.state.mediaID,
        destroy: component.state.mediaDestroy,
        embed: $('#media_embed').val(),
        full_width: $('#media_full_width').is(':checked'),
        kind: $('#media_tab_image').is(':visible') ? 'images' : 'embeds',
        image_alt: $('#media_image_alt').val(),
        image_attachment_cache_url: component.state.mediaImageAttachmentCacheURL,
        image_attachment_content_type: component.state.mediaImageAttachmentContentType,
        image_attachment_file_name: component.state.mediaImageAttachmentFileName,
        image_attachment_file_size: component.state.mediaImageAttachmentFileSize,
        image_attachment_url: component.state.mediaImageAttachmentURL,
        image_attachment_thumbnail_url: component.state.mediaImageAttachmentURL,
        image_attachment_small_url: component.state.mediaImageAttachmentSmallURL,
        image_attachment_small_fixed_url: component.state.mediaImageAttachmentSmallFixedURL,
        image_attachment_medium_url: component.state.mediaImageAttachmentMediumURL,
        image_attachment_medium_fixed_url: component.state.mediaImageAttachmentMediumFixedURL,
        image_attachment_large_url: component.state.mediaImageAttachmentLargeURL,
        image_attachment_large_fixed_url: component.state.mediaImageAttachmentLargeFixedURL,
        image_attachment_jumbo_url: component.state.mediaImageAttachmentJumboURL,
        image_attachment_jumbo_fixed_url: component.state.mediaImageAttachmentJumboFixedURL,
        image_id: component.state.mediaImageID,
        image_title: $('#media_image_title').val(),
      },
    };
    // mediaHelpers.updateLocalImages(component);
    if (placement_type === 'group_background_placement') {
      component.updateGroup(
        $('#media_group_uuid').val(),
        { [placement_type]: null },
        () => {
          if (component.state.mediaDestroy) {
            component.updateGroup(
              $('#media_group_uuid').val(),
              {
                [placement_type]: {
                  id: component.state.mediaID,
                  image_id: component.state.mediaImageID,
                  destroy: component.state.mediaDestroy,
                },
              },
            );
          } else {
            component.updateGroup(
              $('#media_group_uuid').val(),
              changes,
            );
          }
        },
      );
    } else {
      component.updateBlock(
        $('#media_group_uuid').val(),
        $('#media_block_uuid').val(),
        { [placement_type]: null },
        () => {
          if (component.state.mediaDestroy) {
            component.updateBlock(
              $('#media_group_uuid').val(),
              $('#media_block_uuid').val(),
              {
                [placement_type]: {
                  id: component.state.mediaID,
                  image_id: component.state.mediaImageID,
                  destroy: component.state.mediaDestroy,
                },
              },
            );
          } else {
            component.updateBlock(
              $('#media_group_uuid').val(),
              $('#media_block_uuid').val(),
              changes,
            );
          }
        },
      );
    }
  },
  removeMediaImage(component) {
    component.setState({
      mediaDestroy: '1',
      mediaImageAttachmentCacheURL: undefined,
      mediaImageAttachmentContentType: undefined,
      mediaImageAttachmentFileName: undefined,
      mediaImageAttachmentFileSize: undefined,
      mediaImageAttachmentURL: undefined,
      mediaImageAttachmentThumbnailURL: undefined,
      // mediaImageID: undefined,
      mediaImageStatus: 'empty',
      mediaImageTitle: undefined,
    });
  },
};

// window.mediaHelpers = mediaHelpers;
