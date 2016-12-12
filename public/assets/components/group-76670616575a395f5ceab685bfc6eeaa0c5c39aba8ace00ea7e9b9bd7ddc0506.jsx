(function() {
  var Group;

  Group = React.createClass({
    propTypes: {
      blocks: React.PropTypes.object,
      editing: React.PropTypes.bool,
      sidebarPosition: React.PropTypes.string,
      switchSidebarPosition: React.PropTypes.func,
      type: React.PropTypes.string,
      updateGroup: React.PropTypes.func,
      uuid: React.PropTypes.number
    },
    componentDidMount: function() {
      return $(this.getDOMNode()).find('.webpage-group-popover').popover({
        container: 'body',
        placement: 'top',
        trigger: 'hover',
        delay: {
          show: 500,
          hide: 0
        }
      });
    },
    render: function() {
      return <div className={this.groupClass()} data-uuid={this.props.uuid}>
      <div className="webpage-fields">
        <input type="hidden" name={this.inputName('id')} value={this.props.id} />
        <input type="hidden" name={this.inputName('type')} value={this.props.type} />
        <input type="hidden" name={this.inputName('kind')} value={this.props.kind} />
        <input type="hidden" name={this.inputName('height')} value={this.props.height} />
        <input type="hidden" name={this.inputName('max_blocks')} value={this.props.max_blocks} />
        <input type="hidden" name={this.inputName('position')} value={this.props.position} />
        <input type="hidden" name={this.inputName('hero_position')} value={this.props.hero_position} />
        <input type="hidden" name={this.inputName('custom_class')} value={this.props.custom_class} />
        {this.renderRemovedBlocksInputs()}
      </div>
      {this.renderMoveHandle()}
      {this.renderCustomHandle()}
      {this.renderSidebarSwitcher()}
      {this.renderCallToActionSizeChanger()}
      {this.renderHeroToggles()}
      <div className={this.groupRowClass()}>
        {this.renderBlocks()}
      </div>
    </div>;
    },
    renderRemovedBlocksInputs: function() {
      var block, destroyName, i, idName, len, ref, results;
      ref = this.props.removedBlocks;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        block = ref[i];
        destroyName = (this.inputName('blocks_attributes')) + "[" + block.index + "][_destroy]";
        idName = (this.inputName('blocks_attributes')) + "[" + block.index + "][id]";
        results.push(<div key={block.index}>
        <input type="hidden" name={destroyName} value="1" />
        <input type="hidden" name={idName} value={block.id} />
      </div>);
      }
      return results;
    },
    groupClass: function() {
      if (this.props.sidebarPosition === 'left') {
        if (this.props.type === 'SidebarGroup') {
          return 'webpage-group webpage-group-sidebar webpage-group-sidebar-left';
        } else {
          return 'webpage-group webpage-group-basic webpage-group-basic-right';
        }
      } else {
        if (this.props.type === 'SidebarGroup') {
          return 'webpage-group webpage-group-sidebar webpage-group-sidebar-right';
        } else {
          return 'webpage-group webpage-group-basic webpage-group-basic-left';
        }
      }
    },
    groupRowClass: function() {
      switch (this.props.type) {
        case 'CallToActionGroup':
          return 'webpage-group-horizontal-container row';
        case 'SidebarGroup':
          return 'webpage-group-vertical-container';
        default:
          return '';
      }
    },
    inputName: function(name) {
      return "groups_attributes[" + this.props.uuid + "][" + name + "]";
    },
    renderMoveHandle: function() {
      if (this.props.editing) {
        return <span className="fa fa-reorder webpage-group-sort-handle" />;
      }
    },
    renderCustomHandle: function() {
      if (this.props.editing) {
        return <span onClick={this.props.editCustomGroup.bind(null, this.props.uuid)} className="fa fa-cog webpage-group-custom-handle" />;
      }
    },
    renderSidebarSwitcher: function() {
      if (this.props.editing && this.props.type === 'SidebarGroup') {
        return <span onClick={this.props.switchSidebarPosition} className="fa webpage-group-sidebar-handle" />;
      }
    },
    renderCallToActionSizeChanger: function() {
      if (this.props.editing && this.props.type === 'CallToActionGroup') {
        return <strong onClick={this.props.updateGroup.bind(null, this.props.uuid, { max_blocks: this.nextMaxBlocksValue() })} className="webpage-group-call-to-action-size-handle">{this.props.max_blocks}x</strong>;
      }
    },
    renderHeroToggles: function() {
      if (this.props.editing && this.props.type === 'HeroGroup') {
        return <span className="webpage-group-hero-handles">
	{this.renderHeroSwitchers()}
        {this.renderHeroAdder()}
      </span>;
      }
    },
    renderHeroSwitchers: function() {
      var blocks;
      blocks = _.reject(this.props.blocks, function(block) {
        return block === void 0;
      });
      if (Object.keys(blocks).length > 1) {
        return _.map(_.sortBy(_.reject(this.props.blocks, function(block) {
          return block === void 0;
        }), 'position'), this.renderHeroSwitcher);
      }
    },
    renderHeroSwitcher: function(block) {
      if (this.props.current_block === block.uuid) {
        return <span onClick={this.props.updateGroup.bind(null, this.props.uuid, { current_block: block.uuid })} className="fa fa-square webpage-group-hero-switch-handle" data-uuid={block.uuid} key={block.uuid} />;
      } else {
        return <span onClick={this.props.updateGroup.bind(null, this.props.uuid, { current_block: block.uuid })} className="fa fa-square-o webpage-group-hero-switch-handle webpage-group-popover" data-content="Click to edit this slide" data-uuid={block.uuid} key={block.uuid} />;
      }
    },
    renderHeroAdder: function() {
      var blocksLength;
      blocksLength = Object.keys(_.reject(this.props.blocks, function(block) {
        return block === void 0;
      })).length;
      if (blocksLength === 1) {
        return <span onClick={this.props.insertBlock.bind(null, this.props.uuid, 'HeroBlock')} className="fa fa-plus-square-o webpage-group-hero-add-handle webpage-group-popover" data-content="Click to turn hero into rotating carousel" />;
      } else if (blocksLength < 6) {
        return <span onClick={this.props.insertBlock.bind(null, this.props.uuid, 'HeroBlock')} className="fa fa-plus-square-o webpage-group-hero-add-handle webpage-group-popover" data-content="Click to add slide to carousel" />;
      }
    },
    renderBlocks: function() {
      if (this.props.max_blocks) {
        return _.map(_.sortBy(_.reject(this.props.blocks, function(block) {
          return block === void 0;
        }).slice(0, this.props.max_blocks), 'position'), this.renderBlock);
      } else {
        return _.map(_.sortBy(this.props.blocks, 'position'), this.renderBlock);
      }
    },
    renderBlock: function(block) {
      if (block) {
        return <Block key={block.uuid} custom_class={this.props.custom_class} editing={this.props.editing} kind={this.props.kind} current_block={this.props.current_block} groupHeight={this.props.height} max_blocks={this.props.max_blocks} groupInputName={this.inputName('blocks_attributes')} contents_path={this.props.contents_path} reviews_path={this.props.reviews_path} {...block} />;
      }
    },
    nextMaxBlocksValue: function() {
      if (this.props.max_blocks === 3) {
        return 4;
      } else if (this.props.max_blocks === 4) {
        return 2;
      } else {
        return 3;
      }
    }
  });

  window.Group = Group;

}).call(this);
