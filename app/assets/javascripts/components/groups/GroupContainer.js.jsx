const GroupContainer = React.createClass({
  // getInitialState() {
  //   # super(props)
  //   this.state = {
  //     group: props.group,
  //   }
  //   this.updateGroup = this.updateGroup.bind(this)
  //   this.updateBlock = this.updateBlock.bind(this)
  //   this.removeBlock = this.removeBlock.bind(this)
  //
  //   this.editMedia = this.editMedia.bind(this)
  //   this.editLink = this.editLink.bind(this)
  //   this.editHeroSettings = this.editHeroSettings.bind(this)
  //   this.compressHero = this.compressHero.bind(this)
  //   this.expandHero = this.expandHero.bind(this)
  // }

  componentDidMount() {
    $(ReactDOM.findDOMNode(this)).find('.webpage-group-popover').popover({
      container: 'body',
      placement: 'top',
      trigger: 'hover',
      delay: {
        show: 500,
        hide: 0
      }
    });
  },

  updateGroup(attrs) {
    this.props.updateGroup(this.props.group.uuid, attrs);
  },

  updateBlock(blockId, attrs) {
    this.props.updateBlock(this.props.group.uuid, blockId, attrs);
  },

  // removeBlock(uuid) {
  //   this.props.removeBlock(uuid);
  // },

  editHeroSettings(block) {
    heroHelpers.editHeroSettings(this.props.group.uuid, block);
  },

  compressHero(event) {
    heroHelpers.compressHero(this, event);
  },

  expandHero(event) {
    heroHelpers.expandHero(this, event);
  },

  editMedia(type, block) {
    this.props.editMedia(type, block, this.props.group);
  },

  editLink(block) {
    this.props.editLink(this.props.group.uuid, block);
  },

  editTaglineSettings(block) {
    taglineHelpers.editTaglineSettings(this.props.group.uuid, block);
  },

  editDefaultSettings(block, isCallToAction) {
    defaultSettingsHelpers.editDefaultSettings(this.props.group.uuid, block, isCallToAction);
  },

  editFeedSettings(block) {
    feedHelpers.editFeedSettings(this.props.group.uuid, block);
  },

  editSupportLocalSettings(block) {
    supportLocalHelpers.editSupportLocalSettings(this.props.group.uuid, block);
  },

  editCalendarSettings(block) {
    calendarHelpers.editCalendarSettings(this.props.group.uuid, block);
  },

  editContactFormSettings(block) {
    contactFormHelpers.editContactFormSettings(this.props.group.uuid, block);
  },

  editReviewsSettings(block) {
    reviewHelpers.editReviewsSettings(this.props.group.uuid, block);
  },

  removeBlock(blockUUID, event) {
    this.props.removeBlock(this.props.group.uuid, blockUUID, event);
  },

  getFields() {
    return {
      id: this.props.group.id,
      type: this.props.group.type,
      kind: this.props.group.kind,
      height: this.props.group.height,
      max_blocks: this.props.group.maxBlocks,
      position: this.props.group.position,
      background_color: this.props.group.background_color,
      foreground_color: this.props.group.foreground_color,
      hero_position: this.props.group.hero_position,
      custom_class: this.props.group.custom_class,
      'aspect_ratio][height': this.props.group.aspect_ratio ? this.props.group.aspect_ratio.height : '',
      'aspect_ratio][width': this.props.group.aspect_ratio ? this.props.group.aspect_ratio.width : '',
    };
  },

  groupRowClass(type) {
    switch (type) {
      case 'CallToActionGroup':
        return 'webpage-group-horizontal-container p-h-xl row';
      case 'SidebarGroup':
        return 'webpage-group-vertical-container';
    }
  },

  groupClass() {
    const custom_class = this.props.group.custom_class
    if (this.props.sidebarPosition === 'left') {
      if (this.props.group.type === 'SidebarGroup') {
        return `webpage-group webpage-group-sidebar webpage-group-sidebar-left ${custom_class}`;
      } else { return `webpage-group webpage-group-basic webpage-group-basic-right ${custom_class}`; }
    } else if (this.props.group.type === 'SidebarGroup') {
      return `webpage-group webpage-group-sidebar webpage-group-sidebar-right ${custom_class}`;
    } else { return `webpage-group webpage-group-basic webpage-group-basic-left p-h-xl ${custom_class}`; }
  },

  // inputName: (name) ->
  //   "groups_attributes[#{this.props.uuid}][#{name}]"

  renderRemovedBlocksInputs() {
    let destroyName;
    let idName;
    return Array.from(this.props.group.removedBlocks).map((block) => {
      destroyName = `groups_attributes[${this.props.group.uuid}][blocks_attributes][${block.index}][_destroy]`
      idName = `groups_attributes[${this.props.group.uuid}][blocks_attributes][${block.index}][id]`
      return (
        <div key={block.index}>
          <input type="hidden" name={destroyName} value="1" />
          <input type="hidden" name={idName} value={block.id} />
        </div>
      );
    });
  },

  groupBackgroundInputName(name) {
    return `groups_attributes[${this.props.group.uuid}][group_background_placement_attributes][${name}]`
  },

  renderGroupBackgroundPlacementInputs() {
    const placement = this.props.group.group_background_placement;
    if (placement) {
      return(
        <div>
          <input type="hidden" name={this.groupBackgroundInputName('_destroy')} value={placement.destroy} key={'_destroy'} />
          <input type="hidden" name={this.groupBackgroundInputName('id')} value={placement.id} key={'id'} />
          <input type="hidden" name={this.groupBackgroundInputName('kind')} value={placement.kind} key={'kind'} />
          <input type="hidden" name={this.groupBackgroundInputName('embed')} value={placement.embed} key={'embed'} />
          <input type="hidden" name={this.groupBackgroundInputName('image_id')} value={placement.image_id} key={'image_id'} />
          <input type="hidden" name={this.groupBackgroundInputName('image_alt')} value={placement.image_alt} key={'image_alt'} />
          <input type="hidden" name={this.groupBackgroundInputName('image_title')} value={placement.image_title} key={'image_title'} />
          <input type="hidden" name={this.groupBackgroundInputName('image_attachment_cache_url')} value={placement.image_attachment_cache_url} key={'image_attachment_cache_url'} />
          <input type="hidden" name={this.groupBackgroundInputName('image_attachment_content_type')} value={placement.image_attachment_content_type} key={'image_attachment_content_type'} />
          <input type="hidden" name={this.groupBackgroundInputName('image_attachment_file_name')} value={placement.image_attachment_file_name} key={'image_attachment_file_name'} />
          <input type="hidden" name={this.groupBackgroundInputName('image_attachment_file_size')} value={placement.image_attachment_file_size} key={'image_attachment_file_size'} />
        </div>
      )
    }
  },

  render() {
    const callbacks = Object.assign({}, this.props.callbacks, {
      updateBlock: this.updateBlock,
      removeBlock: this.removeBlock,
      editMedia: this.editMedia,
      editLink: this.editLink,
      editHeroSettings: this.editHeroSettings,
      compressHero: this.compressHero,
      expandHero: this.expandHero,
      editTaglineSettings: this.editTaglineSettings, // .bind(this),
      editDefaultSettings: this.editDefaultSettings, // .bind(this),
      editFeedSettings: this.editFeedSettings, // .bind(this),
      editSupportLocalSettings: this.editSupportLocalSettings, // .bind(this),
      editCalendarSettings: this.editCalendarSettings, // .bind(this),
      editContactFormSettings: this.editContactFormSettings, // .bind(this),
      editReviewsSettings: this.editReviewsSettings, // .bind(this),
    });
    let { group } = this.props;
    return (
      <div className={`${this.groupClass()} ${group.kind}-group`} data-uuid={group.uuid}>
        <div className="webpage-fields">
          <WebpageFields uuid={group.uuid} inputPrefix="groups_attributes" fields={this.getFields()} removedBlocks={this.renderRemovedBlocksInputs()}/>
          {this.renderGroupBackgroundPlacementInputs()}
        </div>
        {this.renderMoveHandle()}
        {this.renderCustomHandle()}
        {this.renderBackgroundHandle()}
        {this.renderSidebarSwitcher()}
        {this.renderCallToActionSizeChanger()}
        {this.renderHeroToggles()}

        <Group
          uuid={group.uuid}
          groupRowClass={this.groupRowClass(group.type)}
          callbacks={callbacks}
          {...callbacks}
          webpageState={this.props.webpageState}
          {...this.props.webpageState}
          {...group}
        />
      </div>
    );
  },

  renderMoveHandle() {
    if (this.props.editing) {
      return <span className="fa fa-reorder webpage-group-sort-handle" style={{color: 'black'}}/>;
    }
  },

  renderCustomHandle() {
    if (this.props.editing) {
      return <span onClick={groupHelpers.editCustomGroup.bind(null, this.props.group)} className="fa fa-cog webpage-group-custom-handle" style={{ color: 'black' }}/>;
    }
  },

  renderBackgroundHandle() {
    if (this.props.editing && (this.props.group.type !== 'HeroGroup')) {
      return <span onClick={() => this.editMedia('group_background', null)} className="fa fa-area-chart webpage-group-background-handle" style={{ color: 'black' }}/>;
    }
  },

  renderSidebarSwitcher() {
    if (this.props.editing && (this.props.group.type === 'SidebarGroup')) {
      return <span onClick={this.props.switchSidebarPosition} className="fa webpage-group-sidebar-handle" style={{ color: 'black' }}/>;
    }
  },

  renderCallToActionSizeChanger() {
    if (this.props.editing && (this.props.group.type === 'CallToActionGroup')) {
      return <strong onClick={this.props.updateGroup.bind(null, this.props.group.uuid, { maxBlocks: this.nextMaxBlocksValue() })} className="webpage-group-call-to-action-size-handle" style={{ color: 'black' }}>{this.props.group.maxBlocks}x</strong>;
    }
  },

  renderHeroToggles() {
    if (this.props.editing && (this.props.group.type === 'HeroGroup')) {
      return (<ul className="webpage-group-hero-handles">
        <ul className="sortable-hero-handles" data-group-uuid={this.props.group.uuid} style={{ color: 'black' }}>
          {this.renderHeroSwitchers()}
          {this.renderHeroAdder()}
        </ul>
      </ul>);
    }
  },

  renderHeroSwitchers() {
    let blocks = _.reject(this.props.group.blocks, block => block === undefined);
    if (Object.keys(blocks).length > 1) {
      return _.map(_.sortBy(_.reject(this.props.group.blocks, block => block === undefined), 'position'), this.renderHeroSwitcher);
    }
  },

  renderHeroSwitcher(block) {
    if (this.props.group.currentBlock === block.uuid) {
      return <li onClick={this.props.updateGroup.bind(null, this.props.group.uuid, { currentBlock: block.uuid })} className="fa fa-square webpage-group-hero-switch-handle" data-uuid={block.uuid}  key={block.uuid} style={{ color: 'black' }} />;
    }

    return <li onClick={this.props.updateGroup.bind(null, this.props.group.uuid || this.props.group.uuid, { currentBlock: block.uuid })} className="fa fa-square-o webpage-group-hero-switch-handle webpage-group-popover" data-content="Click to edit this slide. Drag to change ordering" data-uuid={block.uuid} key={block.uuid} style={{ color: 'black' }} />;
  },


  renderHeroAdder() {
    let blocksLength = Object.keys(_.reject(this.props.group.blocks, block => block === undefined)).length;
    if (blocksLength === 1) {
      return <span onClick={this.props.insertBlock.bind(null, this.props.group.uuid || this.props.group.uuid, 'HeroBlock')} className="fa fa-plus-square-o webpage-group-hero-add-handle webpage-group-popover" data-content="Click to turn hero into rotating carousel" style={{ color: 'black' }}/>;
    } else if (blocksLength < 6) {
      return <span onClick={this.props.insertBlock.bind(null, this.props.group.uuid || this.props.group.uuid, 'HeroBlock')} className="fa fa-plus-square-o webpage-group-hero-add-handle webpage-group-popover" data-content="Click to add slide to carousel" style={{ color: 'black' }}/>;
    }
  },

  nextMaxBlocksValue() {
    if (this.props.group.maxBlocks === 3) {
      return 4;
    } else if (this.props.group.maxBlocks === 4) {
      return 2;
    }
    return 3;
  }
});

GroupContainer.propTypes = {
  group: React.PropTypes.shape({
    removedBlocks: React.PropTypes.arrayOf(React.PropTypes.object),
  }).isRequired,
  editMedia: React.PropTypes.func,
};
