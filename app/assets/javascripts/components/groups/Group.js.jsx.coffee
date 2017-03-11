# // import React, { PropTypes } from 'react';

Group = React.createClass
  groupInputName: ->
    "groups_attributes[#{this.props.uuid}][blocks_attributes]"

  render: ->
    `<BlockList
      aspect_ratio={this.props.aspect_ratio}
      kind={this.props.kind}
      blocks={this.props.blocks}
      maxBlocks={this.props.maxBlocks}
      currentBlock={this.props.currentBlock}
      groupInputName={this.groupInputName()}
      groupRowClass={this.props.groupRowClass}
      editing
      callbacks={this.props.callbacks}
      {...this.props.callbacks}
      webpageState={this.props.webpageState}
      {...this.props.webpageState}
    />`


Group.propTypes = {
  blocks: React.PropTypes.object,
  editMedia: React.PropTypes.func.isRequired,
}


# // export default Group;
window.Group = Group
