# // import React, { PropTypes } from 'react'

BlockList = React.createClass
  renderBlocks: ->
    if this.props.maxBlocks
      _.map _.sortBy(_.reject(this.props.blocks, (block) -> block is undefined).slice(0, this.props.maxBlocks), 'position'), this.renderBlock
    else
      _.map _.sortBy(_.reject(this.props.blocks, (block) -> block is undefined), 'position'), this.renderBlock

  render: () ->
    blocks = []
    if this.props.maxBlocks
      blocks = _.sortBy(_.reject(this.props.blocks, (block) -> block is undefined).slice(0, this.props.maxBlocks), 'position')
    else
      blocks = _.sortBy(_.reject(this.props.blocks, (block) -> block is undefined), 'position')


    return (
      `<div className={this.props.groupRowClass}>
        {blocks.map(block => (
          <BlockContainer
            key={block.uuid}
            aspect_ratio={this.props.aspect_ratio}
            kind={this.props.kind}
            block={block}
            maxBlocks={this.props.maxBlocks}
            groupInputName={this.props.groupInputName}
            currentBlock={this.props.currentBlock}
            callbacks={this.props.callbacks}
            {...this.props.callbacks}
            webpageState={this.props.webpageState}
            {...this.props.webpageState}
          />
            ))}
      </div>`
    )

BlockList.propTypes = {
  blocks: React.PropTypes.object.isRequired,
  editMedia: React.PropTypes.func.isRequired,
}
# // export default BlockList;

window.BlockList = BlockList
