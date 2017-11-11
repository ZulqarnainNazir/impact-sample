# // import React, { PropTypes } from 'react'

BlockContainer = React.createClass
  updateBlock: (attrs) ->
    this.props.updateBlock(this.props.block.uuid, attrs)

  editText: (event) ->
    event.preventDefault()
    this.props.updateBlock(this.props.block.uuid, { richText: !(this.props.block.richText) })

  editMedia: (type, event) ->
    event.preventDefault()
    this.props.editMedia(type, this.props.block)

  editLink: (event) ->
    event.preventDefault()
    this.props.editLink(this.props.block)

  editDefaultSettings: (event) ->
    event.preventDefault()
    this.props.editDefaultSettings(this.props.block)

  editHeroSettings: (event) ->
    event.preventDefault()
    this.props.editHeroSettings(this.props.block)

  compressHero: (event) ->
    this.props.compressHero(event)

  expandHero: (event) ->
    this.props.expandHero(event)

  editTaglineSettings: (event) ->
    event.preventDefault()
    this.props.editTaglineSettings(this.props.block)

  updateText: (richText) ->
    content = richText
    if (richText == '<br>')
      content = ''
    this.props.updateBlock(this.props.block.uuid, { text: content })

  updateHeading: (richText) ->
    content = richText
    if (richText == '<br>')
      content = ''
    this.props.updateBlock(this.props.block.uuid, { heading: content })

  updateSubheading: (richText) ->
    content = richText
    if (richText == '<br>')
      content = ''
    this.props.updateBlock(this.props.block.uuid, { subheading: content })

  prevTheme: (themes, event) ->
    event.preventDefault()
    themeIdx = (themes.indexOf(this.props.block.theme) - 1)
    themeIdx = if themeIdx < 0 then themes.length - 1 else themeIdx
    this.props.updateBlock(this.props.block.uuid, { theme: themes[themeIdx] })

  nextTheme: (themes, event) ->
    event.preventDefault()
    themeIdx = (themes.indexOf(this.props.block.theme) + 1)
    themeIdx = if themeIdx > themes.length - 1 then 0 else themeIdx
    this.props.updateBlock(this.props.block.uuid, { theme: themes[themeIdx] })

  editFeedSettings: (event) ->
    event.preventDefault()
    this.props.editFeedSettings(this.props.block)

  editSupportLocalSettings: (event) ->
    event.preventDefault()
    this.props.editSupportLocalSettings(this.props.block)

  editContactFormSettings: (event) ->
    event.preventDefault()
    this.props.editContactFormSettings(this.props.block)

  editReviewsSettings: (event) ->
    event.preventDefault()
    this.props.editReviewsSettings(this.props.block)

  removeBlock: (event) ->
    this.props.removeBlock(this.props.block.uuid, event)

  # // [
  # //  'HeroBlock', 'TaglineBlock', 'CallToActionBlock', 'ContentBlock',
  # //  'BlogFeedBlock', 'ReviewsBlock', 'SidebarContentBlock',
  # //  'SidebarBlogFeedBlock', 'SidebarEventsFeedBlock', 'AboutBlock',
  # //  'TeamBlock', 'ContactBlock'
  # // ]

  defaultBlockAttributes: (blockType) ->
    switch (blockType)
      when 'HeroBlock'
        # return {
        # editText: this.editText # #.bind(null),
        editBackground: this.editMedia.bind(null, 'background'),
        editImage: this.editMedia.bind(null, 'image'),
        editLink: this.editLink #.bind(null),
        editCustom: this.editHeroSettings #.bind(null),
        prevTheme: this.prevTheme.bind(null, ['full', 'right', 'left']),
        nextTheme: this.nextTheme.bind(null, ['full', 'right', 'left']),
        compress: this.compressHero #.bind(null),
        expand: this.expandHero #.bind(null),
        heading: LoremTitle,
        text: LoremHeading,
        theme: 'full',
        themes: ['full', 'right', 'left'],
        well_style: 'transparent',
        postion_header: 'below',
        updateHeading: this.updateHeading #.bind(null),
        updateText: this.updateText #.bind(null)
      when 'TaglineBlock'
        return {
          # editText: this.editText #.bind(null),
          editLink: this.editLink #.bind(null),
          editCustom: this.editTaglineSettings #.bind(null),
          prevTheme: this.prevTheme.bind(null, ['left', 'center', 'right']),
          nextTheme: this.nextTheme.bind(null, ['left', 'center', 'right']),
          text: LoremHeading,
          theme: 'left',
          themes: ['left', 'center', 'right'],
          well_style: 'transparent',
          updateText: this.updateText #.bind(null),
        }
      when 'CallToActionBlock'
        return {
          # editText: this.editText #.bind(null),
          editImage: this.editMedia.bind(null, 'image'),
          editLink: this.editLink #.bind(null),
          editCustom: this.editDefaultSettings #.bind(null),
          heading: LoremTitle,
          text: LoremHeading,
          sort: (e) -> e.preventDefault(),
          updateHeading: this.updateHeading #.bind(null),
          updateText: this.updateText #.bind(null),
        }
      when 'ContentBlock'
        return {
          # editText: this.editText #.bind(null),
          editImage: this.editMedia.bind(null, 'image'),
          editCustom: this.editDefaultSettings #.bind(null),
          prevTheme: this.prevTheme.bind(null, ['left', 'left_half', 'right_half', 'right', 'text', 'image']),
          nextTheme: this.nextTheme.bind(null, ['left', 'left_half', 'right_half', 'right', 'text', 'image']),
          heading: LoremHeading,
          text: LoremFull,
          theme: 'left',
          themes: ['left', 'left_half', 'right_half', 'right', 'text', 'image'],
          updateHeading: this.updateHeading #.bind(null),
          updateText: this.updateText #.bind(null),
        }
      when 'BlogFeedBlock'
        return {
          editCustom: this.editFeedSettings #.bind(null),
          items_limit: 4,
        }
      when 'ReviewsBlock'
        return {
          editCustom: this.editReviewsSettings #.bind(null),
          theme: 'default',
          style: 'default',
        }
      when 'SidebarContentBlock'
        return {
          # editText: this.editText #.bind(null),
          editImage: this.editMedia.bind(null, 'image'),
          editLink: this.editLink #.bind(null),
          editCustom: this.editDefaultSettings #.bind(null),
          heading: LoremTitle,
          text: LoremHeading,
          sort: (e) -> e.preventDefault(),
          updateHeading: this.updateHeading #.bind(null),
          updateText: this.updateText #.bind(null),
        }
      when 'SidebarBlogFeedBlock'
        return {
          editCustom: this.editFeedSettings #.bind(null),
          sort: (e) -> e.preventDefault(),
          items_limit: 4,
        }
      when 'SidebarEventsFeedBlock'
        return {
          editCustom: this.editFeedSettings #.bind(null),
          sort: (e) -> e.preventDefault(),
          items_limit: 4,
        }
      when 'AboutBlock'
        return {
          # editText: this.editText #.bind(null),
          editBackground: this.editMedia.bind(null, 'background'),
          editImage: this.editMedia.bind(null, 'image'),
          prevTheme: this.prevTheme.bind(null, ['banner', 'left']),
          nextTheme: this.nextTheme.bind(null, ['banner', 'left']),
          heading: LoremTitle,
          subheading: LoremHeading,
          text: LoremFull,
          theme: 'banner',
          themes: ['banner', 'left'],
          updateHeading: this.updateHeading #.bind(null),
          updateSubheading: this.updateSubheading #.bind(null),
          updateText: this.updateText #.bind(null),
        }
      when 'TeamBlock'
        return {
          prevTheme: this.prevTheme.bind(null, ['vertical', 'horizontal']),
          nextTheme: this.nextTheme.bind(null, ['vertical', 'horizontal']),
          teamMembers: this.props.teamMembers,
          theme: 'vertical',
          themes: ['vertical', 'horizontal'],
        }
      when 'ContactBlock'
        return {
          # editText: this.editText #.bind(null),
          prevTheme: this.prevTheme.bind(null, ['right', 'banner', 'inline', 'content']),
          nextTheme: this.nextTheme.bind(null, ['right', 'banner', 'inline', 'content']),
          text: LoremFull,
          theme: 'right',
          themes: ['right', 'banner', 'inline', 'content'],
          updateText: this.updateText #.bind(null),
          location: this.props.location,
          openings: this.props.openings,
        }
      when 'SupportLocalBlock'
        return { editCustom: this.editSupportLocalSettings }
      when 'ContactFormBlock'
        return { editCustom: this.editContactFormSettings }
      # default:
      #   return {}

  render: () ->
    aspectRatio = if this.props.aspect_ratio then (this.props.aspect_ratio.height / this.props.aspect_ratio.width) * 100 else ''
    block = Object.assign({}, this.defaultBlockAttributes(this.props.block.type), this.props.block)
    `<Block
      uuid={block.uuid}
      kind={this.props.kind}
      maxBlocks={this.props.maxBlocks}
      currentBlock={this.props.currentBlock}
      groupInputName={this.props.groupInputName}
      removeBlock={this.removeBlock}
      callbacks={this.props.callbacks}
      aspect_ratio={aspectRatio}
      webpageState={this.props.webpageState}
      {...this.props.webpageState}
      {...block}
    />`

BlockContainer.propTypes = {
  block: React.PropTypes.shape({
    id: React.PropTypes.number,
  }).isRequired,
  editMedia: React.PropTypes.func,
  groupInputName: React.PropTypes.string,
  currentBlock: React.PropTypes.number,
  # // removeBlock: React.PropTypes.function,
}

# // export default BlockContainer
window.BlockContainer = BlockContainer
