(function() {
  var Webpage;

  Webpage = React.createClass({
    propTypes: {
      backgroundColor: React.PropTypes.string,
      browserButtonsSrc: React.PropTypes.string,
      bulkUploadPath: React.PropTypes.string,
      foregroundColor: React.PropTypes.string,
      groupTypes: React.PropTypes.array,
      groups: React.PropTypes.array,
      hasMultipleBusinesses: React.PropTypes.bool,
      imagesPath: React.PropTypes.string,
      internalWebpages: React.PropTypes.array,
      linkColor: React.PropTypes.string,
      presignedPost: React.PropTypes.object,
      showOnlyLocalMediaLibraryOption: React.PropTypes.bool,
      sidebarPosition: React.PropTypes.string
    },
    getInitialState: function() {
      return {
        editing: true,
        groups: this.getInitialGroupsState(),
        mediaImageProgress: 0,
        mediaImageStatus: 'empty',
        mediaKind: 'images',
        mediaLibraryHasMoreImages: true,
        mediaLibraryImages: [],
        mediaLibraryLoaded: false,
        mediaLibraryLoadedAll: false,
        mediaLibraryLocalOnly: true,
        mediaLibraryPage: 1,
        removedGroups: [],
        sidebarPosition: this.props.sidebarPosition === 'left' ? 'left' : 'right'
      };
    },
    getInitialGroupsState: function() {
      var block, blocks, group, groups, i, j, k, l, len, len1, ref;
      groups = {};
      ref = this.props.groups;
      for (i = k = 0, len = ref.length; k < len; i = ++k) {
        group = ref[i];
        group.uuid = i;
        group.removedBlocks = [];
        groups[i] = group;
        blocks = group.blocks;
        group.blocks = {};
        for (j = l = 0, len1 = blocks.length; l < len1; j = ++l) {
          block = blocks[j];
          block.uuid = j;
          group.blocks[j] = this.defaultBlockAttributes(i, j, block.type, block);
        }
        if (group.type === 'HeroGroup') {
          if (Object.keys(group.blocks).length > 0) {
            group.current_block = 0;
          } else {
            group.current_block = void 0;
          }
        }
      }
      return groups;
    },
    componentDidMount: function() {
      $('#link_modal').on('change', 'input[type="radio"]', this.toggleLinkOptions);
      $('#feed_settings_modal').on('change', 'input[type="radio"]', this.toggleFeedLinkOptions);
      $('.webpage-save-toggle-on').on('click', function() {
        $('.webpage-save').addClass('webpage-save-visible');
        $('.webpage-save-toggle-on').hide();
        return $('.webpage-save-toggle-off').show();
      });
      $('.webpage-save-toggle-off').hide().on('click', function() {
        $('.webpage-save').removeClass('webpage-save-visible');
        $('.webpage-save-toggle-off').hide();
        return $('.webpage-save-toggle-on').show();
      });
      this.enableSortables();
      this.resetLink();
      this.toggleLinkOptions();
      this.resetFeedSettings();
      this.toggleFeedLinkOptions();
      this.resetMedia();
      return $('.webpage-save span.btn-default').popover({
        container: 'body',
        placement: 'top',
        trigger: 'hover',
        delay: {
          show: 500,
          hide: 0
        }
      });
    },
    componentDidUpdate: function() {
      if ($('#add_main_block_options > *').length === 0) {
        $('#add_main_block_label').hide();
      } else {
        $('#add_main_block_label').show();
      }
      if ($('#add_sidebar_block_options > *').length === 0) {
        return $('#add_sidebar_block_label').hide();
      } else {
        return $('#add_sidebar_block_label').show();
      }
    },
    disableSortable: function() {
      return $('.webpage-container').sortable('destroy');
    },
    enableSortables: function() {
      $('.webpage-container').sortable({
        axis: 'y',
        container: '.webpage-container',
        expandOnHover: 400,
        forceHelperSize: true,
        forcePlaceholderSize: true,
        handle: '.webpage-group-sort-handle',
        helper: 'clone',
        items: '> .webpage-group',
        opacity: 0.5,
        placeholder: 'webpage-group-placeholder',
        revert: 100,
        startCollapsed: false,
        tabSize: 20,
        tolerance: 'pointer',
        start: this.startWebpageGroupsSorting,
        stop: this.stopWebpageGroupsSorting
      });
      $('.webpage-group-horizontal-container').sortable({
        axis: 'x',
        container: '.webpage-group-horizontal-container',
        expandOnHover: 400,
        forceHelperSize: true,
        forcePlaceholderSize: true,
        handle: '.webpage-block-sort-handle',
        helper: 'clone',
        items: '> .webpage-block',
        opacity: 0.5,
        placeholder: 'webpage-block-placeholder',
        revert: 100,
        startCollapsed: false,
        tabSize: 20,
        tolerance: 'pointer',
        stop: this.stopWebpageBlocksSorting
      });
      return $('.webpage-group-vertical-container').sortable({
        axis: 'y',
        container: '.webpage-group-vertical-container',
        expandOnHover: 400,
        forceHelperSize: true,
        forcePlaceholderSize: true,
        handle: '.webpage-block-sort-handle',
        helper: 'clone',
        items: '> .webpage-block',
        opacity: 0.5,
        placeholder: 'webpage-block-placeholder',
        revert: 100,
        startCollapsed: false,
        tabSize: 20,
        tolerance: 'pointer',
        stop: this.stopWebpageBlocksSorting
      });
    },
    startWebpageGroupsSorting: function(event, ui) {
      var group;
      group = this.state.groups[ui.item.data('uuid')];
      if (group && group.type === 'SidebarGroup') {
        return ui.placeholder.addClass('webpage-group-sidebar-placeholder-' + this.state.sidebarPosition);
      }
    },
    stopWebpageGroupsSorting: function() {
      var container, groupUUIDs;
      container = $('.webpage-container');
      groupUUIDs = container.sortable('toArray', {
        attribute: 'data-uuid'
      });
      container.sortable('cancel');
      return this.sortWebpageGroups(groupUUIDs);
    },
    stopWebpageBlocksSorting: function(event, ui) {
      var blockUUIDs, container, group;
      container = ui.item.closest('.webpage-group-horizontal-container, .webpage-group-vertical-container');
      group = container.closest('.webpage-group');
      blockUUIDs = container.sortable('toArray', {
        attribute: 'data-uuid'
      });
      container.sortable('cancel');
      return this.sortWebpageBlocks(group.data('uuid'), blockUUIDs);
    },
    sortWebpageGroups: function(groupUUIDs) {
      var changes;
      changes = {};
      _.each(groupUUIDs, function(uuid, i) {
        var obj;
        return $.extend(changes, (
          obj = {},
          obj["" + uuid] = {
            $merge: {
              position: i
            }
          },
          obj
        ));
      });
      return this.setState({
        groups: React.addons.update(this.state.groups, changes)
      });
    },
    sortWebpageBlocks: function(groupUUID, blockUUIDs) {
      var changes, obj;
      changes = (
        obj = {},
        obj["" + groupUUID] = {
          blocks: {}
        },
        obj
      );
      _.each(blockUUIDs, function(uuid, i) {
        var obj1;
        return $.extend(changes[groupUUID].blocks, (
          obj1 = {},
          obj1["" + uuid] = {
            $merge: {
              position: i
            }
          },
          obj1
        ));
      });
      return this.setState({
        groups: React.addons.update(this.state.groups, changes)
      });
    },
    toggleEditing: function() {
      return this.setState({
        editing: !this.state.editing
      });
    },
    defaultBlockAttributes: function(group_uuid, block_uuid, block_type, argumentAttributes) {
      var blockSpecificAttributes, commonAttributes;
      commonAttributes = {
        removeBlock: this.removeBlock.bind(null, group_uuid, block_uuid),
        type: block_type,
        uuid: block_uuid,
        position: $('.webpage-group[data-uuid="' + group_uuid + '"] .webpage-block').length
      };
      blockSpecificAttributes = (function() {
        switch (block_type) {
          case 'HeroBlock':
            return {
              editText: this.editText.bind(null, group_uuid, block_uuid),
              editBackground: this.editMedia.bind(null, group_uuid, block_uuid, 'background'),
              editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image'),
              editLink: this.editLink.bind(null, group_uuid, block_uuid),
              editCustom: this.editHeroSettings.bind(null, group_uuid, block_uuid),
              prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid),
              nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid),
              compress: this.compressHero.bind(null, group_uuid),
              expand: this.expandHero.bind(null, group_uuid),
              heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.',
              theme: 'full',
              themes: ['full', 'right', 'left'],
              well_style: 'light',
              postion_header: 'below',
              updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid),
              updateText: this.updateText.bind(null, group_uuid, block_uuid)
            };
          case 'TaglineBlock':
            return {
              editText: this.editText.bind(null, group_uuid, block_uuid),
              editLink: this.editLink.bind(null, group_uuid, block_uuid),
              editCustom: this.editTaglineSettings.bind(null, group_uuid, block_uuid),
              prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid),
              nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid),
              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.',
              theme: 'left',
              themes: ['left', 'center', 'right'],
              well_style: 'light',
              updateText: this.updateText.bind(null, group_uuid, block_uuid)
            };
          case 'CallToActionBlock':
            return {
              editText: this.editText.bind(null, group_uuid, block_uuid),
              editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image'),
              editLink: this.editLink.bind(null, group_uuid, block_uuid),
              editCustom: this.editDefaultSettings.bind(null, group_uuid, block_uuid),
              heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.',
              sort: function(e) {
                return e.preventDefault();
              },
              updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid),
              updateText: this.updateText.bind(null, group_uuid, block_uuid)
            };
          case 'ContentBlock':
            return {
              editText: this.editText.bind(null, group_uuid, block_uuid),
              editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image'),
              editCustom: this.editDefaultSettings.bind(null, group_uuid, block_uuid),
              prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid),
              nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid),
              heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.',
              theme: 'left',
              themes: ['left', 'left_half', 'right_half', 'right', 'text', 'image'],
              updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid),
              updateText: this.updateText.bind(null, group_uuid, block_uuid)
            };
          case 'BlogFeedBlock':
            return {
              editCustom: this.editFeedSettings.bind(null, group_uuid, block_uuid),
              items_limit: 4
            };
          case 'ReviewsBlock':
            return {
              editCustom: this.editReviewsSettings.bind(null, group_uuid, block_uuid),
              theme: 'default',
              style: 'default'
            };
          case 'SidebarContentBlock':
            return {
              editText: this.editText.bind(null, group_uuid, block_uuid),
              editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image'),
              editLink: this.editLink.bind(null, group_uuid, block_uuid),
              editCustom: this.editDefaultSettings.bind(null, group_uuid, block_uuid),
              heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.',
              sort: function(e) {
                return e.preventDefault();
              },
              updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid),
              updateText: this.updateText.bind(null, group_uuid, block_uuid)
            };
          case 'SidebarBlogFeedBlock':
            return {
              editCustom: this.editFeedSettings.bind(null, group_uuid, block_uuid),
              sort: function(e) {
                return e.preventDefault();
              },
              items_limit: 4
            };
          case 'SidebarEventsFeedBlock':
            return {
              editCustom: this.editFeedSettings.bind(null, group_uuid, block_uuid),
              sort: function(e) {
                return e.preventDefault();
              },
              items_limit: 4
            };
          case 'AboutBlock':
            return {
              editText: this.editText.bind(null, group_uuid, block_uuid),
              editBackground: this.editMedia.bind(null, group_uuid, block_uuid, 'background'),
              editImage: this.editMedia.bind(null, group_uuid, block_uuid, 'image'),
              prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid),
              nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid),
              heading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
              subheading: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.',
              theme: 'banner',
              themes: ['banner', 'left'],
              updateHeading: this.updateHeading.bind(null, group_uuid, block_uuid),
              updateSubheading: this.updateSubheading.bind(null, group_uuid, block_uuid),
              updateText: this.updateText.bind(null, group_uuid, block_uuid)
            };
          case 'TeamBlock':
            return {
              prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid),
              nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid),
              teamMembers: this.props.teamMembers,
              theme: 'vertical',
              themes: ['vertical', 'horizontal']
            };
          case 'ContactBlock':
            return {
              editText: this.editText.bind(null, group_uuid, block_uuid),
              prevTheme: this.prevTheme.bind(null, group_uuid, block_uuid),
              nextTheme: this.nextTheme.bind(null, group_uuid, block_uuid),
              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum finibus ut tortor quis mattis. Donec sit amet hendrerit risus. Maecenas sed orci metus. Nulla viverra bibendum quam, eu ullamcorper felis dignissim sit amet. Pellentesque quis urna nec arcu malesuada accumsan. Nunc eu lacinia est. Vestibulum cursus consequat interdum.',
              theme: 'right',
              themes: ['right', 'banner', 'inline', 'content'],
              updateText: this.updateText.bind(null, group_uuid, block_uuid),
              location: this.props.location,
              openings: this.props.openings
            };
        }
      }).call(this);
      return $.extend({}, commonAttributes, blockSpecificAttributes, argumentAttributes);
    },
    insertGroup: function(group_type, block_type) {
      var block_uuid, block_uuid_1, block_uuid_2, block_uuid_3, blocks, changes, group_uuid, messageKey, obj, obj1, obj2, obj3;
      this.disableSortable();
      $('.webpage-save span.btn-default').popover('hide');
      group_uuid = Math.floor(Math.random() * Math.pow(10, 10));
      messageKey = /Sidebar/.exec(block_type) ? 'insertSidebarSuccessMessage' : 'insertMainSuccessMessage';
      if (group_type === 'CallToActionGroup') {
        block_uuid_1 = Math.floor(Math.random() * Math.pow(10, 10));
        block_uuid_2 = Math.floor(Math.random() * Math.pow(10, 10));
        block_uuid_3 = Math.floor(Math.random() * Math.pow(10, 10));
        blocks = (
          obj = {},
          obj["" + block_uuid_1] = this.defaultBlockAttributes(group_uuid, block_uuid_1, block_type),
          obj["" + block_uuid_2] = this.defaultBlockAttributes(group_uuid, block_uuid_2, block_type),
          obj["" + block_uuid_3] = this.defaultBlockAttributes(group_uuid, block_uuid_3, block_type),
          obj
        );
      } else {
        block_uuid = Math.floor(Math.random() * Math.pow(10, 10));
        blocks = (
          obj1 = {},
          obj1["" + block_uuid] = this.defaultBlockAttributes(group_uuid, block_uuid, block_type),
          obj1
        );
      }
      changes = (
        obj2 = {},
        obj2["" + messageKey] = {
          $set: 'Success, block appended to page.'
        },
        obj2.groups = {
          $merge: (
            obj3 = {},
            obj3["" + group_uuid] = {
              type: group_type,
              uuid: group_uuid,
              kind: 'container',
              max_blocks: group_type === 'CallToActionGroup' ? 3 : void 0,
              current_block: group_type === 'HeroGroup' ? block_uuid : void 0,
              position: $('.webpage-group').length,
              blocks: blocks,
              removedBlocks: []
            },
            obj3
          )
        },
        obj2
      );
      return this.setState(React.addons.update(this.state, changes), this.finishInsert.bind(null, messageKey));
    },
    insertBlock: function(group_uuid, block_type) {
      var block_uuid, changes, group, messageKey, obj, obj1, obj2;
      this.disableSortable();
      $('.webpage-save span.btn-default').popover('hide');
      group = this.state.groups[group_uuid];
      block_uuid = Math.floor(Math.random() * Math.pow(10, 10));
      messageKey = /Sidebar/.exec(block_type) ? 'insertSidebarSuccessMessage' : 'insertMainSuccessMessage';
      changes = (
        obj = {},
        obj["" + messageKey] = {
          $set: 'Success, block appended to page.'
        },
        obj.groups = (
          obj1 = {},
          obj1["" + group_uuid] = {
            blocks: {
              $merge: (
                obj2 = {},
                obj2["" + block_uuid] = this.defaultBlockAttributes(group_uuid, block_uuid, block_type),
                obj2
              )
            },
            current_block: {
              $set: group.type === 'HeroGroup' ? block_uuid : void 0
            }
          },
          obj1
        ),
        obj
      );
      return this.setState(React.addons.update(this.state, changes), this.finishInsert.bind(null, messageKey));
    },
    finishInsert: function(messageKey) {
      this.enableSortables();
      return setTimeout(this.clearSuccessMessage.bind(null, messageKey), 1500);
    },
    clearSuccessMessage: function(messageKey) {
      var obj;
      return this.setState((
        obj = {},
        obj["" + messageKey] = null,
        obj
      ));
    },
    removeBlock: function(group_uuid, block_uuid, event) {
      var block, changes, current_block, group, obj, obj1, obj2;
      event.preventDefault();
      group = this.state.groups[group_uuid];
      if (_.reject(group.blocks, function(block) {
        return block === void 0;
      }).length > 1) {
        block = group.blocks[block_uuid];
        if (group.type === 'HeroGroup') {
          current_block = _.reject(group.blocks, function(b) {
            return b === void 0 || b.uuid === block_uuid;
          })[0].uuid;
        } else {
          current_block = void 0;
        }
        changes = {
          groups: (
            obj = {},
            obj["" + group_uuid] = {
              blocks: (
                obj1 = {},
                obj1["" + block_uuid] = {
                  $set: void 0
                },
                obj1
              ),
              removedBlocks: {
                $push: [
                  {
                    index: block_uuid,
                    id: block.id
                  }
                ]
              },
              current_block: {
                $set: current_block
              }
            },
            obj
          )
        };
      } else {
        changes = {
          groups: (
            obj2 = {},
            obj2["" + group_uuid] = {
              $set: void 0
            },
            obj2
          ),
          removedGroups: {
            $push: [
              {
                index: group_uuid,
                id: group.id
              }
            ]
          }
        };
      }
      return this.setState(React.addons.update(this.state, changes));
    },
    updateGroup: function(group_uuid, attributes, callback) {
      var block_uuid, blocks, blocks_count, changes, group, k, n, obj, ref;
      group = this.state.groups[group_uuid];
      blocks_count = _.size(_.reject(this.props.blocks, function(block) {
        return block === void 0;
      }));
      if (group.type === 'CallToActionGroup' && blocks_count < attributes.max_blocks) {
        blocks = $.extend({}, group.blocks);
        for (n = k = 1, ref = attributes.max_blocks - blocks_count; 1 <= ref ? k <= ref : k >= ref; n = 1 <= ref ? ++k : --k) {
          block_uuid = Math.floor(Math.random() * Math.pow(10, 10));
          blocks[block_uuid] = this.defaultBlockAttributes(group_uuid, block_uuid, 'CallToActionBlock');
        }
        attributes['blocks'] = blocks;
      }
      changes = (
        obj = {},
        obj["" + group_uuid] = {
          $merge: attributes
        },
        obj
      );
      if (callback && !callback.target) {
        return this.setState({
          groups: React.addons.update(this.state.groups, changes)
        }, callback);
      } else {
        return this.setState({
          groups: React.addons.update(this.state.groups, changes)
        });
      }
    },
    updateBlock: function(group_uuid, block_uuid, attributes, callback) {
      var changes, obj, obj1;
      changes = (
        obj = {},
        obj["" + group_uuid] = {
          blocks: (
            obj1 = {},
            obj1["" + block_uuid] = {
              $merge: attributes
            },
            obj1
          )
        },
        obj
      );
      if (callback) {
        return this.setState({
          groups: React.addons.update(this.state.groups, changes)
        }, callback);
      } else {
        return this.setState({
          groups: React.addons.update(this.state.groups, changes)
        });
      }
    },
    editText: function(group_uuid, block_uuid, event) {
      var block, group;
      event.preventDefault();
      group = this.state.groups[group_uuid];
      block = group.blocks[block_uuid];
      return this.updateBlock(group_uuid, block_uuid, {
        richText: block.richText ? false : true
      });
    },
    updateHeading: function(group_uuid, block_uuid, richText) {
      if (richText === '<br>') {
        richText = '';
      }
      return this.updateBlock(group_uuid, block_uuid, {
        heading: richText
      });
    },
    updateSubheading: function(group_uuid, block_uuid, richText) {
      if (richText === '<br>') {
        richText = '';
      }
      return this.updateBlock(group_uuid, block_uuid, {
        subheading: richText
      });
    },
    updateText: function(group_uuid, block_uuid, richText) {
      if (richText === '<br>') {
        richText = '';
      }
      return this.updateBlock(group_uuid, block_uuid, {
        text: richText
      });
    },
    editMedia: function(group_uuid, block_uuid, type, event) {
      var block, group, placement, stateChanges;
      event.preventDefault();
      $('#media_type').val(type);
      $('#media_group_uuid').val(group_uuid);
      $('#media_block_uuid').val(block_uuid);
      group = this.state.groups[group_uuid];
      block = group.blocks[block_uuid];
      placement = (type === 'image' ? block.block_image_placement : block.block_background_placement) || {};
      stateChanges = {
        mediaID: placement.id,
        mediaDestroy: void 0,
        mediaImageAttachmentContentType: placement.image_attachment_content_type,
        mediaImageAttachmentFileName: placement.image_attachment_file_name,
        mediaImageAttachmentFileSize: placement.image_attachment_file_size,
        mediaImageProgress: 0,
        mediaImageStatus: Object.keys(placement).length > 0 ? 'attached' : 'empty',
        mediaImageAttachmentURL: placement.image_attachment_url,
        mediaImageAttachmentCacheURL: void 0,
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
        mediaLibraryPage: 1
      };
      this.setState(stateChanges, function() {
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
        return $('#media_modal').modal('show');
      });
      return this.initializeMediaUpload();
    },
    initializeMediaUpload: function() {
      return $('#media_modal').fileupload({
        dataType: 'XML',
        url: this.props.presignedPost.url,
        formData: this.props.presignedPost.fields,
        paramName: 'file',
        dropZone: '.media_dropzone',
        add: this.mediaUploadAdd,
        progress: this.mediaUploadProgress,
        done: this.mediaUploadDone,
        fail: this.mediaUploadFail
      });
    },
    mediaUploadAdd: function(event, data) {
      var file, formData, reader;
      file = data.files[0];
      reader = new FileReader();
      reader.onload = this.mediaUploadRead.bind(null, file);
      reader.readAsDataURL(file);
      formData = this.props.presignedPost.fields;
      formData['Content-Type'] = file.type;
      data.formData = formData;
      return data.submit();
    },
    mediaUploadRead: function(file, event) {
      var block, group;
      group = this.state.groups[$('#media_group_uuid').val()];
      block = group.blocks[$('#media_block_uuid')];
      if (file.type.match(/^image/)) {
        return this.setState({
          mediaDestroy: void 0,
          mediaImageAttachmentCacheURL: event.target.result,
          mediaImageAttachmentContentType: file.type,
          mediaImageAttachmentFileName: file.name,
          mediaImageAttachmentFileSize: file.size,
          mediaImageAttachmentJumboURL: void 0,
          mediaImageAttachmentJumboFixedURL: void 0,
          mediaImageAttachmentLargeURL: void 0,
          mediaImageAttachmentLargeFixedURL: void 0,
          mediaImageAttachmentMediumURL: void 0,
          mediaImageAttachmentMediumFixedURL: void 0,
          mediaImageAttachmentSmallURL: void 0,
          mediaImageAttachmentSmallFixedURL: void 0,
          mediaImageAttachmentThumbnailURL: void 0,
          mediaImageAttachmentURL: event.target.result,
          mediaImageID: void 0,
          mediaImageStatus: 'uploading',
          mediaImageTitle: ''
        });
      } else {
        this.setState({
          mediaImageStatus: (this.state.mediaImageAttachmentURL && this.state.mediaImageAttachmentURL.length > 0) || (this.state.mediaImageAttachmentURL && this.state.mediaImageAttachmentURL.length > 0) ? 'attached' : 'empty'
        });
        return alert('Only PNG, JPG and GIF images are allowed.');
      }
    },
    mediaUploadProgress: function(event, data) {
      if (this.state.mediaImageStatus === 'uploading') {
        return this.setState({
          mediaImageProgress: parseInt(data.loaded / data.total * 100, 10)
        });
      }
    },
    mediaUploadDone: function(event, data) {
      if (this.state.mediaImageStatus === 'uploading') {
        this.setState({
          mediaImageAttachmentCacheURL: "//" + this.props.presignedPost.host + "/" + ($(data.jqXHR.responseXML).find('Key').text()),
          mediaImageStatus: 'finishing'
        });
        return setTimeout(this.mediaUploadFinish, 500);
      }
    },
    mediaUploadFinish: function() {
      var attributes;
      $('#media_modal').fileupload('destroy');
      attributes = {
        mediaImageProgress: 0,
        mediaImageStatus: 'attached'
      };
      return this.setState(attributes, this.initializeFileUpload);
    },
    mediaUploadFail: function(event, data) {
      if (this.state.mediaImageStatus === 'uploading') {
        return this.setState({
          mediaImageStatus: 'failed'
        });
      }
    },
    updateMedia: function() {
      var changes, obj, placement_type;
      placement_type = $('#media_type').val() === 'image' ? 'block_image_placement' : 'block_background_placement';
      changes = (
        obj = {},
        obj["" + placement_type] = {
          id: this.state.mediaID,
          destroy: this.state.mediaDestroy,
          embed: $('#media_embed').val(),
          full_width: $('#media_full_width').is(':checked'),
          kind: $('#media_tab_image').is(':visible') ? 'images' : 'embeds',
          image_alt: $('#media_image_alt').val(),
          image_attachment_cache_url: this.state.mediaImageAttachmentCacheURL,
          image_attachment_content_type: this.state.mediaImageAttachmentContentType,
          image_attachment_file_name: this.state.mediaImageAttachmentFileName,
          image_attachment_file_size: this.state.mediaImageAttachmentFileSize,
          image_attachment_url: this.state.mediaImageAttachmentURL,
          image_attachment_thumbnail_url: this.state.mediaImageAttachmentURL,
          image_attachment_small_url: this.state.mediaImageAttachmentSmallURL,
          image_attachment_small_fixed_url: this.state.mediaImageAttachmentSmallFixedURL,
          image_attachment_medium_url: this.state.mediaImageAttachmentMediumURL,
          image_attachment_medium_fixed_url: this.state.mediaImageAttachmentMediumFixedURL,
          image_attachment_large_url: this.state.mediaImageAttachmentLargeURL,
          image_attachment_large_fixed_url: this.state.mediaImageAttachmentLargeFixedURL,
          image_attachment_jumbo_url: this.state.mediaImageAttachmentJumboURL,
          image_attachment_jumbo_fixed_url: this.state.mediaImageAttachmentJumboFixedURL,
          image_id: this.state.mediaImageID,
          image_title: $('#media_image_title').val()
        },
        obj
      );
      return this.updateBlock($('#media_group_uuid').val(), $('#media_block_uuid').val(), changes);
    },
    removeMediaImage: function() {
      return this.setState({
        mediaDestroy: '1',
        mediaImageAttachmentCacheURL: void 0,
        mediaImageAttachmentContentType: void 0,
        mediaImageAttachmentFileName: void 0,
        mediaImageAttachmentFileSize: void 0,
        mediaImageAttachmentURL: void 0,
        mediaImageID: void 0,
        mediaImageStatus: 'empty',
        mediaImageTitle: void 0
      });
    },
    showMediaLibrary: function() {
      $('#media_tabs').css('display', 'none');
      $('#media_library').css('display', 'block');
      return this.loadMediaLibraryImages();
    },
    loadMediaLibraryImages: function() {
      return $.get(this.props.imagesPath + "?page=" + this.state.mediaLibraryPage + "&local=" + this.state.mediaLibraryLocalOnly, this.setMediaLibraryImages);
    },
    setMediaLibraryImages: function(data) {
      return this.setState({
        mediaLibraryImages: this.state.mediaLibraryImages.concat(data.images),
        mediaLibraryLoaded: true,
        mediaLibraryLoadedAll: data.images.length < 48,
        mediaLibraryPage: this.state.mediaLibraryPage + 1
      });
    },
    selectMediaLibraryImage: function(image) {
      var changes;
      changes = {
        mediaImageAttachmentCacheURL: void 0,
        mediaImageAttachmentContentType: image.attachment_content_type,
        mediaImageAttachmentFileName: image.attachment_file_name,
        mediaImageAttachmentFileSize: image.attachment_file_size,
        mediaImageAttachmentURL: image.attachment_url,
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
        mediaImageStatus: 'attached'
      };
      return this.setState(changes, this.hideMediaLibrary, function() {
        $('#media_image_alt').val(image.alt);
        return $('#media_image_title').val(image.title);
      });
    },
    toggleMediaLibraryLocalOnly: function() {
      var changes;
      changes = {
        mediaLibraryImages: [],
        mediaLibraryLoaded: false,
        mediaLibraryLoadedAll: false,
        mediaLibraryLocalOnly: !this.state.mediaLibraryLocalOnly,
        mediaLibraryPage: 1
      };
      return this.setState(changes, this.loadMediaLibraryImages);
    },
    hideMediaLibrary: function(event) {
      if (event) {
        event.preventDefault();
      }
      $('#media_tabs').css('display', 'block');
      return $('#media_library').css('display', 'none');
    },
    resetMedia: function() {
      var stateChanges;
      stateChanges = {
        mediaDestroy: void 0,
        mediaImageAttachmentContentType: void 0,
        mediaImageAttachmentFileName: void 0,
        mediaImageAttachmentFileSize: void 0,
        mediaImageAttachmentURL: void 0,
        mediaImageProgress: 0,
        mediaImageStatus: 'empty',
        mediaImageTitle: void 0,
        mediaKind: 'images',
        mediaLibraryImages: [],
        mediaLibraryLoaded: false,
        mediaLibraryLoadedAll: false,
        mediaLibraryPage: 1
      };
      return this.setState(stateChanges, function() {
        $('#media_embed').val('');
        $('#media_full_width').prop('checked', false);
        $('#media_image_alt').val('');
        $('#media_image_title').val('');
        $('a[href="#media_tab_image"]').tab('show');
        $('#media_tabs').css('display', 'block');
        return $('#media_library').css('display', 'none');
      });
    },
    editCustomGroup: function(group_uuid, event) {
      var group;
      event.preventDefault();
      group = this.state.groups[group_uuid];
      $('#custom_group_uuid').val(group_uuid);
      $('#custom_group_custom_class').val(group.custom_class);
      if (group.type === 'HeroGroup') {
        $('#custom_group_height_fields').show();
        $('#custom_group_height').val(parseInt(group.height) > 0 ? parseInt(group.height) : '');
        $('#hero_position_fields').show();
        $('#hero_position').val(['below', 'behind'].indexOf(group.hero_position) > 0 ? group.hero_position : 'below');
      } else {
        $('#custom_group_height_fields').hide();
        $('#custom_group_height').val('');
        $('#hero_position_fields').hide();
      }
      return $('#custom_group_modal').modal('show');
    },
    updateCustomGroup: function() {
      var group;
      group = this.state.groups[$('#custom_group_uuid').val()];
      if (group.type === 'HeroGroup') {
        return this.updateGroup($('#custom_group_uuid').val(), {
          custom_class: $('#custom_group_custom_class').val(),
          height: $('#custom_group_height').val(),
          hero_position: $('#hero_position').val()
        });
      } else {
        return this.updateGroup($('#custom_group_uuid').val(), {
          custom_class: $('#custom_group_custom_class').val(),
          height: void 0
        });
      }
    },
    resetCustomGroup: function() {
      $('#custom_group_uuid').val('');
      $('#custom_group_custom_class').val('');
      $('#custom_group_height').val('');
      return $('#hero_position').val('below');
    },
    editLink: function(group_uuid, block_uuid, event) {
      var block, group;
      event.preventDefault();
      group = this.state.groups[group_uuid];
      block = group.blocks[block_uuid];
      $('#link_group_uuid').val(group_uuid);
      $('#link_block_uuid').val(block_uuid);
      $('#link_id').val(block.link_id);
      $('#link_external_url').val(block.link_external_url && block.link_external_url.length > 0 ? block.link_external_url : 'http://');
      $('#link_label').val(block.link_label && block.link_label.length > 0 ? block.link_label : 'Learn More');
      $('#link_no_follow').prop('checked', block.link_no_follow ? true : false);
      $('#link_target_blank').prop('checked', block.link_target_blank ? true : false);
      $('#link_version_none').prop('checked', ['link_internal', 'link_external'].indexOf(block.link_version) >= 0 ? false : true);
      $('#link_version_internal').prop('checked', block.link_version === 'link_internal');
      $('#link_version_external').prop('checked', block.link_version === 'link_external');
      this.toggleLinkOptions();
      return $('#link_modal').modal('show');
    },
    updateLink: function(group_uuid, block_uuid) {
      this.updateBlock($('#link_group_uuid').val(), $('#link_block_uuid').val(), {
        link_external_url: $('#link_external_url').val(),
        link_id: $('#link_id').val(),
        link_label: $('#link_label').val(),
        link_no_follow: $('#link_no_follow').prop('checked'),
        link_target_blank: $('#link_target_blank').prop('checked'),
        link_version: $('input[name="link_version"]:checked').val()
      });
      return this.resetLink();
    },
    resetLink: function() {
      $('#link_group_uuid').val('');
      $('#link_block_uuid').val('');
      $('#link_id').val('');
      $('#link_external_url').val('http://');
      $('#link_label').val('Learn More');
      $('#link_no_follow').prop('checked', false);
      $('#link_target_blank').prop('checked', false);
      $('#link_version_none').prop('checked', true);
      return this.toggleLinkOptions();
    },
    toggleLinkOptions: function() {
      if ($('#link_version_internal').prop('checked')) {
        $('#link_inputs_default').show();
        $('#link_inputs_internal').show();
        return $('#link_inputs_external').hide();
      } else if ($('#link_version_external').prop('checked')) {
        $('#link_inputs_default').show();
        $('#link_inputs_internal').hide();
        return $('#link_inputs_external').show();
      } else {
        $('#link_inputs_default').hide();
        $('#link_inputs_internal').hide();
        return $('#link_inputs_external').hide();
      }
    },
    editHeroSettings: function(group_uuid, block_uuid, event) {
      var block, group, minicolorOptions;
      event.preventDefault();
      group = this.state.groups[group_uuid];
      block = group.blocks[block_uuid];
      minicolorOptions = {
        control: 'wheel',
        theme: 'block'
      };
      $('#hero_settings_background_color').minicolors($.extend(minicolorOptions, {
        defaultValue: block.background_color || ''
      }));
      $('#hero_settings_foreground_color').minicolors($.extend(minicolorOptions, {
        defaultValue: block.foreground_color || ''
      }));
      $('#hero_settings_group_uuid').val(group_uuid);
      $('#hero_settings_block_uuid').val(block_uuid);
      $('#hero_settings_custom_class').val(block.custom_class);
      $('#hero_settings_well_style').val(['light', 'dark', 'transparent'].indexOf(block.well_style) > 0 ? block.well_style : 'light');
      return $('#hero_settings_modal').modal('show');
    },
    updateHeroSettings: function(group_uuid, block_uuid) {
      return this.updateBlock($('#hero_settings_group_uuid').val(), $('#hero_settings_block_uuid').val(), {
        custom_class: $('#hero_settings_custom_class').val(),
        background_color: $('#hero_settings_background_color').val(),
        foreground_color: $('#hero_settings_foreground_color').val(),
        well_style: $('#hero_settings_well_style').val()
      });
    },
    resetHeroSettings: function() {
      $('#hero_settings_background_color').val('').minicolors('destroy');
      $('#hero_settings_foreground_color').val('').minicolors('destroy');
      $('#hero_settings_custom_class').val('');
      return $('#hero_settings_well_style').val('light');
    },
    expandHero: function(group_uuid, event) {
      event.preventDefault();
      $(event.target).popover('hide');
      this.disableSortable();
      return this.updateGroup(group_uuid, {
        kind: 'full_width'
      }, this.enableSortables);
    },
    compressHero: function(group_uuid, event) {
      event.preventDefault();
      $(event.target).popover('hide');
      this.disableSortable();
      return this.updateGroup(group_uuid, {
        kind: 'container'
      }, this.enableSortables);
    },
    editTaglineSettings: function(group_uuid, block_uuid, event) {
      var block, group;
      event.preventDefault();
      group = this.state.groups[group_uuid];
      block = group.blocks[block_uuid];
      $('#tagline_settings_group_uuid').val(group_uuid);
      $('#tagline_settings_block_uuid').val(block_uuid);
      $('#tagline_settings_custom_class').val(block.custom_class);
      $('#tagline_settings_well_style').val(['light', 'dark', 'transparent'].indexOf(block.well_style) > 0 ? block.well_style : 'light');
      return $('#tagline_settings_modal').modal('show');
    },
    updateTaglineSettings: function(group_uuid, block_uuid) {
      return this.updateBlock($('#tagline_settings_group_uuid').val(), $('#tagline_settings_block_uuid').val(), {
        custom_class: $('#tagline_settings_custom_class').val(),
        well_style: $('#tagline_settings_well_style').val()
      });
    },
    resetTaglineSettings: function() {
      $('#tagline_settings_custom_class').val('');
      return $('#tagline_settings_well_style').val('light');
    },
    editFeedSettings: function(group_uuid, block_uuid, event) {
      var block, group;
      event.preventDefault();
      group = this.state.groups[group_uuid];
      block = group.blocks[block_uuid];
      $('#feed_settings_group_uuid').val(group_uuid);
      $('#feed_settings_block_uuid').val(block_uuid);
      $('#feed_settings_items_limit').val(parseInt(block.items_limit) > 0 ? parseInt(block.items_limit) : 4);
      $('.feed_settings_content_type').prop('checked', false);
      $('#feed_settings_content_type_quick_post').prop('checked', (block.content_types || '').indexOf('QuickPost') >= 0);
      $('#feed_settings_content_type_event').prop('checked', (block.content_types || '').indexOf('Event') >= 0);
      $('#feed_settings_content_type_gallery').prop('checked', (block.content_types || '').indexOf('Gallery') >= 0);
      $('#feed_settings_content_type_before_after').prop('checked', (block.content_types || '').indexOf('BeforeAfter') >= 0);
      $('#feed_settings_content_type_offer').prop('checked', (block.content_types || '').indexOf('Offer') >= 0);
      $('#feed_settings_content_type_post').prop('checked', (block.content_types || '').indexOf('CustomPost') >= 0);
      if ($('.feed_settings_content_type:checked').length === 0) {
        $('.feed_settings_content_type').prop('checked', true);
      }
      $('#feed_settings_content_category_ids').val((block.content_category_ids || '').split(' '));
      $('#feed_settings_content_tag_ids').val((block.content_tag_ids || '').split(' '));
      $('#feed_settings_custom_class').val(block.custom_class);
      $('#feed_settings_link_id').val(block.link_id);
      $('#feed_settings_link_external_url').val(block.link_external_url && block.link_external_url.length > 0 ? block.link_external_url : 'http://');
      $('#feed_settings_link_label').val(block.link_label && block.link_label.length > 0 ? block.link_label : 'View More');
      $('#feed_settings_link_no_follow').prop('checked', block.link_no_follow ? true : false);
      $('#feed_settings_link_target_blank').prop('checked', block.link_target_blank ? true : false);
      $('#feed_settings_link_version_none').prop('checked', ['link_paginate', 'link_internal', 'link_external'].indexOf(block.link_version) >= 0 ? false : true);
      $('#feed_settings_link_version_paginate').prop('checked', block.link_version === 'link_paginate');
      $('#feed_settings_link_version_internal').prop('checked', block.link_version === 'link_internal');
      $('#feed_settings_link_version_external').prop('checked', block.link_version === 'link_external');
      this.toggleFeedLinkOptions();
      return $('#feed_settings_modal').modal('show');
    },
    updateFeedSettings: function(group_uuid, block_uuid) {
      this.updateBlock($('#feed_settings_group_uuid').val(), $('#feed_settings_block_uuid').val(), {
        content_types: _.map($('.feed_settings_content_type:checked'), function(input) {
          return $(input).data().type;
        }).join(' '),
        content_category_ids: ($('#feed_settings_content_category_ids').val() || []).join(' '),
        content_tag_ids: ($('#feed_settings_content_tag_ids').val() || []).join(' '),
        custom_class: $('#feed_settings_custom_class').val(),
        items_limit: $('#feed_settings_items_limit').val(),
        link_external_url: $('#feed_settings_link_external_url').val(),
        link_id: $('#feed_settings_link_id').val(),
        link_label: $('#feed_settings_link_label').val(),
        link_no_follow: $('#feed_settings_link_no_follow').prop('checked'),
        link_target_blank: $('#feed_settings_link_target_blank').prop('checked'),
        link_version: $('input[name="link_version"]:checked').val()
      });
      return this.resetFeedSettings();
    },
    resetFeedSettings: function() {
      $('.feed_settings_content_type').prop('checked', false);
      $('#feed_settings_content_category_ids').val(null);
      $('#feed_settings_content_tag_ids').val(null);
      $('#feed_settings_custom_class').val('');
      $('#feed_settings_items_limit').val(4);
      $('#feed_settings_link_id').val('');
      $('#feed_settings_link_external_url').val('http://');
      $('#feed_settings_link_label').val('View More');
      $('#feed_settings_link_no_follow').prop('checked', false);
      $('#feed_settings_link_target_blank').prop('checked', false);
      $('#feed_settings_link_version_none').prop('checked', true);
      return this.toggleFeedLinkOptions();
    },
    toggleFeedLinkOptions: function() {
      if ($('#feed_settings_link_version_internal').prop('checked')) {
        $('#feed_settings_link_inputs_default').show();
        $('#feed_settings_link_inputs_internal').show();
        return $('#feed_settings_link_inputs_external').hide();
      } else if ($('#feed_settings_link_version_external').prop('checked')) {
        $('#feed_settings_link_inputs_default').show();
        $('#feed_settings_link_inputs_internal').hide();
        return $('#feed_settings_link_inputs_external').show();
      } else {
        $('#feed_settings_link_inputs_default').hide();
        $('#feed_settings_link_inputs_internal').hide();
        return $('#feed_settings_link_inputs_external').hide();
      }
    },
    editReviewsSettings: function(group_uuid, block_uuid, event) {
      var block, group;
      event.preventDefault();
      group = this.state.groups[group_uuid];
      block = group.blocks[block_uuid];
      $('#reviews_settings_group_uuid').val(group_uuid);
      $('#reviews_settings_block_uuid').val(block_uuid);
      $('#reviews_settings_style').val(['default', 'columns'].indexOf(block.style) > 0 ? block.style : 'default');
      return $('#reviews_settings_modal').modal('show');
    },
    updateReviewsSettings: function(group_uuid, block_uuid) {
      return this.updateBlock($('#reviews_settings_group_uuid').val(), $('#reviews_settings_block_uuid').val(), {
        style: $('#reviews_settings_style').val()
      });
    },
    resetReviewsSettings: function() {
      return $('#reviews_settings_style').val('default');
    },
    editDefaultSettings: function(group_uuid, block_uuid, event) {
      var block, group;
      event.preventDefault();
      group = this.state.groups[group_uuid];
      block = group.blocks[block_uuid];
      $('#default_settings_group_uuid').val(group_uuid);
      $('#default_settings_block_uuid').val(block_uuid);
      $('#default_settings_custom_class').val(block.custom_class);
      return $('#default_settings_modal').modal('show');
    },
    updateDefaultSettings: function(group_uuid, block_uuid) {
      return this.updateBlock($('#default_settings_group_uuid').val(), $('#default_settings_block_uuid').val(), {
        custom_class: $('#default_settings_custom_class').val()
      });
    },
    resetDefaultSettings: function() {
      return $('#default_settings_custom_class').val('');
    },
    prevTheme: function(group_uuid, block_uuid, event) {
      var availableThemes, currentTheme, currentThemeIndex, theme;
      event.preventDefault();
      availableThemes = this.state.groups[group_uuid].blocks[block_uuid].themes;
      currentTheme = this.state.groups[group_uuid].blocks[block_uuid].theme;
      currentThemeIndex = availableThemes.indexOf(currentTheme);
      theme = availableThemes[currentThemeIndex - 1] || availableThemes[-1];
      return this.updateBlock(group_uuid, block_uuid, {
        theme: theme
      });
    },
    nextTheme: function(group_uuid, block_uuid, event) {
      var availableThemes, currentTheme, currentThemeIndex, theme;
      event.preventDefault();
      availableThemes = this.state.groups[group_uuid].blocks[block_uuid].themes;
      currentTheme = this.state.groups[group_uuid].blocks[block_uuid].theme;
      currentThemeIndex = availableThemes.indexOf(currentTheme);
      theme = availableThemes[currentThemeIndex + 1] || availableThemes[0];
      return this.updateBlock(group_uuid, block_uuid, {
        theme: theme
      });
    },
    render: function() {
      return <div>
      <style dangerouslySetInnerHTML={{__html: '.webpage-block-content a { color: ' + this.props.linkColor + '; }'}} />
      <div className="webpage-fields">
        <input type="hidden" name="sidebar_position" value={this.state.sidebarPosition} />
        {this.renderRemovedGroupsInputs()}
      </div>
      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc} toggleEditing={this.toggleEditing} editing={this.state.editing}>
        <div style={{position: 'relative', paddingTop: 1, paddingBottom: 1, backgroundColor: this.props.backgroundColor, color: this.props.foregroundColor}}>
          {this.renderFullWidthGroups()}
          <div className="webpage-wrapper">
            <div className="container">
              <div className={this.webpageContainerClassName()}>
                {this.renderContainerGroups()}
              </div>
            </div>
          </div>
        </div>
        <div className="panel-footer clearfix">
          <p className="checkbox pull-right" style={{margin: 0}}>
            <label>
              <input type="checkbox" checked={this.state.editing} onChange={this.toggleEditing} />
              Display Editing Dialogs?
            </label>
          </p>
        </div>
      </BrowserPanel>
      <div id="custom_group_modal" className="modal fade">
        <input id="custom_group_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Custom Group Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="custom_group_custom_class" className="control-label">
                  Set a Custom Class
                </label>
                <input type="text" id="custom_group_custom_class" className="form-control" />
              </div>
	      <div className="form-group" id="custom_group_height_fields">
		<label htmlFor="custom_group_height" className="control-label">
		  Set Fixed Hero Height in Pixels
		</label>
		<input type="text" id="custom_group_height" className="form-control" />
	      </div>
              <div className="form-group" id="hero_position_fields">
                <label htmlFor="hero_position" className="control-label">Position With Header</label>
                <div>
                  <select ref="selectpicker" id="hero_position" className="form-control" defaultValue="false">
                    <option key="below" value="below">Below Header</option>
                    <option key="behind" value="behind">Behind Header</option>
                  </select>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetCustomGroup}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateCustomGroup}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="link_modal" className="modal fade">
        <input id="link_group_uuid" type="hidden" />
        <input id="link_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Add a Link</p>
            </div>
            <div className="modal-body">
              <div className="radio">
                <label>
                  <input id="link_version_none" type="radio" name="link_version" value="link_none" defaultChecked="true"/>
                  Don‘t include a linked button
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="link_version_internal" type="radio" name="link_version" value="link_internal" />
                  Link to an internal webpage on your site
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="link_version_external" type="radio" name="link_version" value="link_external" />
                  Link to an external webpage
                </label>
              </div>
              <div id="link_inputs_internal">
                <hr />
                <div className="form-group">
                  <label htmlFor="link_id" className="control-label">IMPACT Webpage</label>
                  <select id="link_id" className="form-control">
                    {this.renderEditLinkOptions()}
                  </select>
                </div>
              </div>
              <div id="link_inputs_external">
                <hr />
                <div className="form-group">
                  <label htmlFor="link_external_url" className="control-label">External URL</label>
                  <input id="link_external_url" type="text" className="form-control" />
                </div>
              </div>
              <div id="link_inputs_default">
                <div className="form-group">
                  <label htmlFor="link_label" className="control-label">Button Label</label>
                  <input id="link_label" type="text" className="form-control" />
                </div>
                <div className="checkbox">
                  <label>
                    <input id="link_target_blank" type="checkbox" value="1" />
                    Open link in a new window?
                  </label>
                </div>
                <div className="checkbox">
                  <label>
                    <input id="link_no_follow" type="checkbox" value="1" />
                    Add "no-follow" to the link?
                  </label>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetLink}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateLink}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="media_modal" className="modal fade">
        <input id="media_type" type="hidden" />
        <input id="media_group_uuid" type="hidden" />
        <input id="media_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">{this.mediaModalTitle()}</p>
            </div>
            <div className="modal-body">
              <div id="media_tabs">
                <ul className="nav nav-tabs">
                  <li clasName="active"><a href="#media_tab_image" data-toggle="tab">Image</a></li>
                  <li><a href="#media_tab_embed" data-toggle="tab">Embed</a></li>
                </ul>
                <div className="tab-content">
                  <div id="media_tab_image" className="tab-pane fade in active">
                    <div className="form-group">
                      <div className="row">
                        <div className="col-sm-4">
                          {this.renderEditMediaThumbnail()}
                        </div>
                        <div className="col-sm-8">
                          {this.renderEditMediaProgress()}
                          {this.renderEditMediaInputs()}
                          {this.renderEditMediaButtons()}
                        </div>
                      </div>
                    </div>
                  </div>
                  <div id="media_tab_embed" className="tab-pane">
                    <div className="form-group">
                      <textarea id="media_embed" rows="6" className="form-control" />
                    </div>
                  </div>
                </div>
              </div>
              <div id="media_library">
                {this.renderMediaLibraryOnlyLocalCheckbox()}
                <ol className="breadcrumb">
                  <li><a onClick={this.hideMediaLibrary} href="#">Edit Details</a></li>
                  <li className="active">Media Library</li>
                </ol>
                {this.renderMediaLibraryInterior()}
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetMedia}>Cancel</span>
              {this.renderMediaLibrarySaveButton()}
            </div>
          </div>
        </div>
      </div>
      <div id="hero_settings_modal" className="modal fade">
        <input id="hero_settings_group_uuid" type="hidden" />
        <input id="hero_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Hero Layout and Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="hero_settings_well_style" className="control-label">Background Shade</label>
                <div>
                  <select ref="selectpicker" id="hero_settings_well_style" className="form-control" defaultValue="light">
                    <option key="light" value="light">Light</option>
                    <option key="dark" value="dark">Dark</option>
                    <option key="transparent" value="transparent">Transparent</option>
                  </select>
                </div>
              </div>
              <input id="hero_settings_fake_to_receive_focus" type="text" className="hide" />
              <div className="form-group">
                <label htmlFor="hero_settings_background_color" className="control-label">Custom Background Color</label>
                <input id="hero_settings_background_color" type="text" className="form-control" />
              </div>
              <div className="form-group">
                <label htmlFor="hero_settings_foreground_color" className="control-label">Custom Font Color</label>
                <input id="hero_settings_foreground_color" type="text" className="form-control" />
              </div>
              <hr />
              <p className="text-muted small">ADVANCED</p>
              <div className="form-group">
                <label htmlFor="hero_settings_custom_class" className="control-label">
                  Set a Custom Class
                </label>
                <input type="text" id="hero_settings_custom_class" className="form-control" />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetHeroSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateHeroSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="tagline_settings_modal" className="modal fade">
        <input id="tagline_settings_group_uuid" type="hidden" />
        <input id="tagline_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Tagline Layout and Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="tagline_settings_well_style" className="control-label">Background Shade</label>
                <div>
                  <select ref="selectpicker" id="tagline_settings_well_style" className="form-control" defaultValue="light">
                    <option key="light" value="light">Light</option>
                    <option key="dark" value="dark">Dark</option>
                    <option key="transparent" value="transparent">Transparent</option>
                  </select>
                </div>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="tagline_settings_custom_class" className="control-label">
                  Set a Custom Class (Advanced)
                </label>
                <input type="text" id="tagline_settings_custom_class" className="form-control" />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetTaglineSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateTaglineSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="feed_settings_modal" className="modal fade">
        <input id="feed_settings_group_uuid" type="hidden" />
        <input id="feed_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Feed Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="feed_settings_items_limit" className="control-label">
                  Maximum Number of Feed Items to Display
                </label>
                <input type="number" id="feed_settings_items_limit" className="form-control" step="1" />
              </div>
              <div className="radio">
                <label>
                  <input id="feed_settings_link_version_none" type="radio" name="link_version" value="link_none" defaultChecked="true"/>
                  Don‘t include a linked button
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="feed_settings_link_version_paginate" type="radio" name="link_version" value="link_paginate" defaultChecked="true"/>
                  Paginate the current page
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="feed_settings_link_version_internal" type="radio" name="link_version" value="link_internal" />
                  Link to an internal webpage on your site
                </label>
              </div>
              <div className="radio">
                <label>
                  <input id="feed_settings_link_version_external" type="radio" name="link_version" value="link_external" />
                  Link to an external webpage
                </label>
              </div>
              <div id="feed_settings_link_inputs_internal">
                <div className="form-group">
                  <label htmlFor="feed_settings_link_id" className="control-label">IMPACT Webpage</label>
                  <select id="feed_settings_link_id" className="form-control">
                    {this.renderEditLinkOptions()}
                  </select>
                </div>
              </div>
              <div id="feed_settings_link_inputs_external">
                <div className="form-group">
                  <label htmlFor="feed_settings_link_external_url" className="control-label">External URL</label>
                  <input id="feed_settings_link_external_url" type="text" className="form-control" />
                </div>
              </div>
              <div id="feed_settings_link_inputs_default">
                <div className="form-group">
                  <label htmlFor="feed_settings_link_label" className="control-label">Button Label</label>
                  <input id="feed_settings_link_label" type="text" className="form-control" />
                </div>
                <div className="checkbox">
                  <label>
                    <input id="feed_settings_link_target_blank" type="checkbox" value="1" />
                    Open link in a new window?
                  </label>
                </div>
                <div className="checkbox">
                  <label>
                    <input id="feed_settings_link_no_follow" type="checkbox" value="1" />
                    Add "no-follow" to the link?
                  </label>
                </div>
              </div>
              <p><strong>What Types of Content Do You Want to Include?</strong></p>
              <div className="row" style={{marginBottom: 5}}>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_quick_post" type="checkbox" data-type="QuickPost" defaultChecked="true" /> Quick Posts</label>
                  </div>
                </div>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_event" type="checkbox" data-type="Event" defaultChecked="true" /> Events</label>
                  </div>
                </div>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_gallery" type="checkbox" data-type="Gallery" defaultChecked="true" /> Galleries</label>
                  </div>
                </div>
              </div>
              <div className="row" style={{marginTop: 5}}>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_before_after" type="checkbox" data-type="BeforeAfter" defaultChecked="true" /> Before &amp; Afters</label>
                  </div>
                </div>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_offer" type="checkbox" data-type="Offer" defaultChecked="true" /> Offers</label>
                  </div>
                </div>
                <div className="col-xs-4">
                  <div className="checkbox" style={{margin: 0}}>
                    <label><input className="feed_settings_content_type" id="feed_settings_content_type_post" type="checkbox" data-type="CustomPost" defaultChecked="true" /> Custom Posts</label>
                  </div>
                </div>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="feed_settings_content_category_ids" className="control-label">
                  Only Include Content for Categories <small>Leave blank to include all</small>
                </label>
                <select type="text" id="feed_settings_content_category_ids" className="form-control" multiple>
                  {this.renderFeedSettingsCategories()}
                </select>
              </div>
              <div className="form-group">
                <label htmlFor="feed_settings_content_tag_ids" className="control-label">
                  Only Include Content for Tags <small>Leave blank to include all</small>
                </label>
                <select type="text" id="feed_settings_content_tag_ids" className="form-control" multiple>
                  {this.renderFeedSettingsTags()}
                </select>
              </div>
              <hr />
              <div className="form-group">
                <label htmlFor="feed_settings_custom_class" className="control-label">
                  Set a Custom Class (Advanced)
                </label>
                <input type="text" id="feed_settings_custom_class" className="form-control" />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetFeedSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateFeedSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div id="reviews_settings_modal" className="modal fade">
        <input id="reviews_settings_group_uuid" type="hidden" />
        <input id="reviews_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Reviews Layout and Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="reviews_settings_style" className="control-label">Background Shade</label>
                <div>
                  <select ref="selectpicker" id="reviews_settings_style" className="form-control" defaultValue="default">
                    <option key="default" value="default">Default</option>
                    <option key="columns" value="columns">Columns</option>
                  </select>
                </div>
              </div>
              <hr />
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetReviewsSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateReviewsSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>

      <div id="default_settings_modal" className="modal fade">
        <input id="default_settings_group_uuid" type="hidden" />
        <input id="default_settings_block_uuid" type="hidden" />
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <span className="close" data-dismiss="modal">&times;</span>
              <p className="h4 modal-title">Change Default Settings</p>
            </div>
            <div className="modal-body">
              <div className="form-group">
                <label htmlFor="default_settings_custom_class" className="control-label">
                  Set a Custom Class (Advanced)
                </label>
                <input type="text" id="default_settings_custom_class" className="form-control" />
              </div>
            </div>
            <div className="modal-footer">
              <span className="btn btn-default" data-dismiss="modal" onClick={this.resetDefaultSettings}>Cancel</span>
              <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateDefaultSettings}>Save</span>
            </div>
          </div>
        </div>
      </div>
      <div className="webpage-save">
        <div className="container">
          <p className="webpage-save-toggle-on text-right"><i className="fa fa-arrow-circle-up" /> Add Page Elements</p>
          <p className="webpage-save-toggle-off pull-right" style={{position: 'relative', zIndex: 1}}><i className="fa fa-arrow-circle-down" /> Hide Page Options</p>
          <div className="row">
            <div className="col-sm-6">
              <p id="add_main_block_label" style={{marginBottom: 5}}><strong>Add Main Block</strong> <span className="text-success">{this.state.insertMainSuccessMessage}</span></p>
              <div id="add_main_block_options">
                {this.renderInsertHeroGroup()}
                {this.renderInsertTaglineGroup()}
                {this.renderInsertCallToActionGroup()}
                {this.renderInsertContentGroup()}
                {this.renderInsertBlogFeedGroup()}
                {this.renderInsertReviewsGroup()}
                {this.renderInsertAboutGroup()}
                {this.renderInsertTeamGroup()}
                {this.renderInsertContactGroup()}
              </div>
            </div>
            <div className="col-sm-4">
              <p id="add_sidebar_block_label" style={{marginBottom: 5}}><strong>Add Sidebar Block</strong> <span className="text-success">{this.state.insertSidebarSuccessMessage}</span></p>
              <div id="add_sidebar_block_options">
                {this.renderInsertSidebarContent()}
                {this.renderInsertSidebarBlogFeed()}
                {this.renderInsertSidebarEventsFeed()}
                {this.renderInsertSidebarReviews()}
              </div>
            </div>
            <div className="col-sm-2">
              <p style={{marginTop: 5}}><button type="submit" className="btn btn-block btn-success">Save Changes</button></p>
            </div>
          </div>
        </div>
      </div>
    </div>;
    },
    mediaModalTitle: function() {
      if ($('#media_type').val() === 'background') {
        return 'Add Background Image';
      } else {
        return 'Add an Image or Video';
      }
    },
    renderRemovedGroupsInputs: function() {
      var destroyName, group, idName, k, len, ref, results;
      ref = this.state.removedGroups;
      results = [];
      for (k = 0, len = ref.length; k < len; k++) {
        group = ref[k];
        destroyName = "groups_attributes[" + group.index + "][_destroy]";
        idName = "groups_attributes[" + group.index + "][id]";
        results.push(<div key={group.index}>
        <input type="hidden" name={destroyName} value="1" />
        <input type="hidden" name={idName} value={group.id} />
      </div>);
      }
      return results;
    },
    renderEditLinkOptions: function() {
      var k, len, results, sorted, webpage;
      sorted = this.props.internalWebpages.sort(function(a, b) {
        if (a.name > b.name) {
          return 1;
        } else if (a.name < b.name) {
          return -1;
        } else {
          return 0;
        }
      });
      results = [];
      for (k = 0, len = sorted.length; k < len; k++) {
        webpage = sorted[k];
        results.push(<option key={webpage.id} value={webpage.id}>{webpage.name}</option>);
      }
      return results;
    },
    renderEditMediaThumbnail: function() {
      if (this.state.mediaImageAttachmentURL) {
        return <div className="media_dropzone">
        <div className="small">
          <div className="thumbnail"><img style={{width: '100%'}} src={this.mediaImageAttachmentURL()} /></div>
          <div style={{overflow: 'hidden', whiteSpace: 'nowrap'}}><strong>{this.state.mediaImageAttachmentFileName}</strong></div>
          <div>{this.state.mediaImageAttachmentContentType} – {this.state.mediaImageAttachmentFileSize / 1000}KB</div>
        </div>
      </div>;
      } else {
        return <div className="media_dropzone">
        <ImageEmpty padding={20} dropzone={true} />
      </div>;
      }
    },
    mediaImageAttachmentURL: function() {
      if (this.state.mediaImageAttachmentThumbnailURL && this.state.mediaImageAttachmentThumbnailURL.length > 0) {
        return this.state.mediaImageAttachmentThumbnailURL;
      } else {
        return this.state.mediaImageAttachmentURL;
      }
    },
    renderEditMediaProgress: function() {
      if (this.state.mediaImageStatus === 'uploading') {
        return <div>
        <div className="progress">
          <div className="progress-bar progress-bar-striped active" style={{width: this.mediaImageUploadProgressWidthCSS()}} />
        </div>
      </div>;
      } else if (this.state.mediaImageStatus === 'finishing') {
        return <div className="progress">
        <div className="progress-bar progress-bar-success" style={{width: '100%'}} />
      </div>;
      } else if (this.state.mediaImageStatus === 'failed') {
        return <div className="progress">
        <div className="progress-bar progress-bar-danger" style={{width: '100%'}} />
      </div>;
      }
    },
    renderEditMediaInputs: function() {
      if (['uploading', 'finishing', 'attached'].indexOf(this.state.mediaImageStatus) >= 0) {
        return <div>
        <div className="form-group">
          <label htmlFor="media_image_alt" className="control-label"><code>ALT</code> HTML Attribute</label>
          <input id="media_image_alt" type="text" className="form-control" />
        </div>
        <div className="form-group">
          <label htmlFor="media_image_title" className="control-label"><code>Title</code> HTML Attribute</label>
          <input id="media_image_title" type="text" className="form-control" placeholder="Add a description of the image. Can be more than 1 sentence." />
        </div>
      </div>;
      }
    },
    renderEditMediaButtons: function() {
      if (['empty', 'failed', 'attached'].indexOf(this.state.mediaImageStatus) >= 0) {
        return <div>
        <input type="file" className="hidden" ref="fileInput" />
        <span className="btn-group btn-group-sm">
          <span onClick={this.triggerFileInput} className="btn btn-default">
            <i className="fa fa-cloud-upload" /> Upload Image
          </span>
          <span onClick={this.showMediaLibrary} className="btn btn-default">
            <i className="fa fa-th" /> Browse Library
          </span>
        </span>
        {this.renderEditMediaRemoveButton()}
        <hr />
        {this.renderEditMediaUpscaleCheckbox()}
        <hr />
        <p className="small" style={{marginTop: 10}}>Have a lot of images to add? <a href={this.props.bulkUploadPath} target="_blank">Try Bulk Upload</a></p>
      </div>;
      }
    },
    renderEditMediaUpscaleCheckbox: function() {
      if ($('#media_type').val() !== 'background') {
        return <p className="small checkbox" style={{marginTop: 10}}>
        <label>
          <input id="media_full_width" type="checkbox" style={{marginTop: 3}} /> Stretch smaller images to fit full width.
        </label>
      </p>;
      }
    },
    renderEditMediaRemoveButton: function() {
      if (['failed', 'attached'].indexOf(this.state.mediaImageStatus) >= 0) {
        return <span onClick={this.removeMediaImage} className="btn btn-sm btn-danger pull-right">
        <i className="fa fa-close" /> Remove
      </span>;
      }
    },
    renderMediaLibraryOnlyLocalCheckbox: function() {
      if (this.props.showOnlyLocalMediaLibraryOption) {
        return <div className="checkbox pull-right small" style={{marginRight: 10}}>
        <label>
          <input type="checkbox" onChange={this.toggleMediaLibraryLocalOnly} defaultChecked={this.props.showOnlyLocalMediaLibraryOption} style={{marginTop: 2}} />
          Current Site Only
        </label>
      </div>;
      }
    },
    renderMediaLibraryInterior: function() {
      if (this.state.mediaLibraryLoaded) {
        return <div>
        <div className="row row-narrow">
          {this.renderMediaLibraryImages()}
        </div>
        {this.renderMediaLibraryMoreButton()}
      </div>;
      } else {
        return <div className="text-center" style={{marginTop: 50, marginBottom: 50}}>
        <i className="fa fa-spinner fa-spin fa-4x" />
      </div>;
      }
    },
    renderMediaLibraryImages: function() {
      var image, k, len, ref, results;
      if (this.state.mediaLibraryImages.length > 0) {
        ref = this.state.mediaLibraryImages;
        results = [];
        for (k = 0, len = ref.length; k < len; k++) {
          image = ref[k];
          results.push(<div key={image.id} className="col-xs-3 col-sm-2">
          <img onClick={this.selectMediaLibraryImage.bind(null, image)} src={image.attachment_thumbnail_url} alt={image.alt} title={image.title} className="thumbnail" style={{maxWidth: '100%', cursor: 'pointer'}} />
        </div>);
        }
        return results;
      } else {
        return <div className="col-sm-12"><p>Looks like you don’t have any images, go ahead and upload a few.</p></div>;
      }
    },
    renderMediaLibraryMoreButton: function() {
      if (!this.state.mediaLibraryLoadedAll) {
        return <div className="row text-center">
        <div className="col-sm-4 col-sm-offset-4">
          <div onClick={this.loadMediaLibraryImages} className="btn btn-block btn-default">Load More</div>
        </div>
      </div>;
      }
    },
    renderMediaLibrarySaveButton: function() {
      if (['uploading', 'finishing'].indexOf(this.state.mediaImageStatus) >= 0) {
        return <span className="btn btn-primary disabled" data-dismiss="modal" onClick={this.updateMedia}>Save</span>;
      } else {
        return <span className="btn btn-primary" data-dismiss="modal" onClick={this.updateMedia}>Save</span>;
      }
    },
    mediaImageUploadProgressWidthCSS: function() {
      return this.state.mediaImageProgress + "%";
    },
    triggerFileInput: function() {
      return $(this.refs.fileInput.getDOMNode()).click();
    },
    renderFullWidthGroups: function() {
      return _.map(_.sortBy(_.filter(this.state.groups, function(group) {
        return group && group.kind === 'full_width';
      }), 'position'), this.renderGroup);
    },
    renderContainerGroups: function() {
      return _.map(_.sortBy(_.filter(this.state.groups, function(group) {
        return group && group.kind === 'container';
      }), 'position'), this.renderGroup);
    },
    renderGroup: function(group, uuid) {
      if (group) {
        return <Group key={group.uuid} editing={this.state.editing} updateGroup={this.updateGroup} insertBlock={this.insertBlock} editCustomGroup={this.editCustomGroup} sidebarPosition={this.state.sidebarPosition} switchSidebarPosition={this.switchSidebarPosition} contents_path={this.props.contentsPath} reviews_path={this.props.reviewsPath} {...group} />;
      }
    },
    renderInsertHeroGroup: function() {
      if (!(this.props.groupTypes.indexOf('HeroGroup') === -1 || _.find(this.state.groups, function(group) {
        return group && group.type === 'HeroGroup';
      }))) {
        return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'HeroGroup', 'HeroBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a page header" data-content="A Hero is a great way to highlight something - add a large background image for a great visual.">Hero</span>;
      }
    },
    renderInsertTaglineGroup: function() {
      if (this.props.groupTypes.indexOf('TaglineGroup') !== -1) {
        return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'TaglineGroup', 'TaglineBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a simple text row" data-content="Great for adding a tagline or call-to-action with optional linkable button.">Simple Text</span>;
      }
    },
    renderInsertCallToActionGroup: function() {
      if (this.props.groupTypes.indexOf('CallToActionGroup') !== -1) {
        return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'CallToActionGroup', 'CallToActionBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add 2 to 4 columns" data-content="Highlight services or product lines with text, linkable buttons and images.">Columns</span>;
      }
    },
    renderInsertContentGroup: function() {
      if (this.props.groupTypes.indexOf('ContentGroup') !== -1) {
        return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ContentGroup', 'ContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Flexible content options" data-content="Can use a small image or embedded media, all text, or a larger image or embedded media.">Content Block</span>;
      }
    },
    renderInsertBlogFeedGroup: function() {
      if (this.props.groupTypes.indexOf('BlogFeedGroup') !== -1) {
        return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'BlogFeedGroup', 'BlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a content feed" data-content="Keep your site fresh with a large content feed (content posted separately).">Content Feed</span>;
      }
    },
    renderInsertReviewsGroup: function() {
      if (!(this.props.groupTypes.indexOf('ReviewsGroup') === -1 || _.find(this.state.groups, function(group) {
        return group && group.type === 'ReviewsGroup';
      }))) {
        return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ReviewsGroup', 'ReviewsBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a reviews widget" data-content="Keep your site fresh with a rotating reviews widget (content posted separately).">Reviews</span>;
      }
    },
    renderInsertAboutGroup: function() {
      if (!(this.props.groupTypes.indexOf('AboutGroup') === -1 || _.find(this.state.groups, function(group) {
        return group && group.type === 'AboutGroup';
      }))) {
        return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'AboutGroup', 'AboutBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>About Content</span>;
      }
    },
    renderInsertTeamGroup: function() {
      if (!(this.props.groupTypes.indexOf('TeamGroup') === -1 || _.find(this.state.groups, function(group) {
        return group && group.type === 'TeamGroup';
      }))) {
        return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'TeamGroup', 'TeamBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Team Members</span>;
      }
    },
    renderInsertContactGroup: function() {
      if (!(this.props.groupTypes.indexOf('ContactGroup') === -1 || _.find(this.state.groups, function(group) {
        return group && group.type === 'ContactGroup';
      }))) {
        return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ContactGroup', 'ContactBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Contact Information</span>;
      }
    },
    renderInsertSidebarContent: function() {
      var group;
      if (this.props.groupTypes.indexOf('SidebarContentGroup') !== -1) {
        group = _.find(this.state.groups, function(group) {
          return group && group.type === 'SidebarGroup';
        });
        if (group) {
          return <span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Flexible content options" data-content="Can use a small image or embedded media and text in the sidebar.">Content Block</span>;
        } else {
          return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Flexible content options" data-content="Can use a small image or embedded media and text in the sidebar.">Content Block</span>;
        }
      }
    },
    renderInsertSidebarBlogFeed: function() {
      var group;
      if (this.props.groupTypes.indexOf('SidebarBlogFeedGroup') !== -1) {
        group = _.find(this.state.groups, function(group) {
          return group && group.type === 'SidebarGroup';
        });
        if (group) {
          return <span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarBlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a smaller feed of content" data-content="Keep your site fresh with a small content feed (content posted separately).">Content Feed</span>;
        } else {
          return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarBlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a smaller feed of content" data-content="Keep your site fresh with a small content feed (content posted separately).">Content Feed</span>;
        }
      }
    },
    renderInsertSidebarEventsFeed: function() {
      var group;
      if (this.props.groupTypes.indexOf('SidebarEventsFeedGroup') !== -1) {
        group = _.find(this.state.groups, function(group) {
          return group && group.type === 'SidebarGroup';
        });
        if (group && !_.find(group.blocks, function(block) {
          return block && block.type === 'SidebarEventsFeedBlock';
        })) {
          return <span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarEventsFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add an event-specific feed" data-content="Highlight upcoming events automatically showing nearest events first (content posted separately).">Event Feed</span>;
        } else if (!group) {
          return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarEventsFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add an event-specific feed" data-content="Highlight upcoming events automatically showing nearest events first (content posted separately).">Event Feed</span>;
        }
      }
    },
    renderInsertSidebarReviews: function() {
      var group;
      if (this.props.groupTypes.indexOf('SidebarReviewsGroup') !== -1) {
        group = _.find(this.state.groups, function(group) {
          return group && group.type === 'SidebarGroup';
        });
        if (group && !_.find(group.blocks, function(block) {
          return block && block.type === 'SidebarReviewsBlock';
        })) {
          return <span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarReviewsBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a reviews widget" data-content="Keep your site fresh with a rotating reviews widget (content posted separately).">Reviews</span>;
        } else if (!group) {
          return <span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarReviewsBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a reviews widget" data-content="Keep your site fresh with a rotating reviews widget (content posted separately).">Reviews</span>;
        }
      }
    },
    renderFeedSettingsCategories: function() {
      var category, k, len, ref, results;
      ref = this.props.contentCategories;
      results = [];
      for (k = 0, len = ref.length; k < len; k++) {
        category = ref[k];
        results.push(<option value={category.id}>{category.name}</option>);
      }
      return results;
    },
    renderFeedSettingsTags: function() {
      var k, len, ref, results, tag;
      ref = this.props.contentTags;
      results = [];
      for (k = 0, len = ref.length; k < len; k++) {
        tag = ref[k];
        results.push(<option value={tag.id}>{tag.name}</option>);
      }
      return results;
    },
    switchSidebarPosition: function() {
      if (this.state.sidebarPosition === 'right') {
        return this.setState({
          sidebarPosition: 'left'
        });
      } else {
        return this.setState({
          sidebarPosition: 'right'
        });
      }
    },
    webpageContainerClassName: function() {
      if (this.props.wrapContainer === 'true') {
        return 'webpage-container webpage-container-wrapper';
      } else {
        return 'webpage-container';
      }
    }
  });

  window.Webpage = Webpage;

}).call(this);
