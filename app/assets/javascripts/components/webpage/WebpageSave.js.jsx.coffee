WebpageSave = React.createClass
  insertGroup: (groupType, blockType) ->
    this.props.insertGroup(groupType, blockType)

  insertBlock: (groupId, blockType) ->
    this.props.insertBlock(groupId, blockType)

  renderInsertHeroGroup: ->
    unless this.props.groupTypes.indexOf('HeroGroup') is -1 or _.find(this.props.groups, (group) -> group and group.type is 'HeroGroup')
      `<span className="btn btn-sm btn-default" onClick={this.props.insertGroup.bind(null, 'HeroGroup', 'HeroBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a page header" data-content="A Hero is a great way to highlight something - add a large background image for a great visual.">Hero</span>`

  renderInsertTaglineGroup: ->
    unless this.props.groupTypes.indexOf('TaglineGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.props.insertGroup.bind(null, 'TaglineGroup', 'TaglineBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a simple text row" data-content="Great for adding a tagline or call-to-action with optional linkable button.">Simple Text</span>`

  renderInsertCallToActionGroup: ->
    unless this.props.groupTypes.indexOf('CallToActionGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'CallToActionGroup', 'CallToActionBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add 2 to 4 columns" data-content="Highlight services or product lines with text, linkable buttons and images.">Columns</span>`

  renderInsertContentGroup: ->
    unless this.props.groupTypes.indexOf('ContentGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ContentGroup', 'ContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Flexible content options" data-content="Can use a small image or embedded media, all text, or a larger image or embedded media.">Content Block</span>`

  renderInsertBlogFeedGroup: ->
    unless this.props.groupTypes.indexOf('BlogFeedGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'BlogFeedGroup', 'BlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a content feed" data-content="Keep your site fresh with a large content feed (content posted separately).">Content Feed</span>`

  renderInsertReviewsGroup: ->
    unless this.props.groupTypes.indexOf('ReviewsGroup') is -1 or _.find(this.props.groups, (group) -> group and group.type is 'ReviewsGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ReviewsGroup', 'ReviewsBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a reviews widget" data-content="Keep your site fresh with a rotating reviews widget (content posted separately).">Reviews</span>`

  renderInsertAboutGroup: ->
    unless this.props.groupTypes.indexOf('AboutGroup') is -1 or _.find(this.props.groups, (group) -> group and group.type is 'AboutGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'AboutGroup', 'AboutBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>About Content</span>`

  renderInsertTeamGroup: ->
    unless this.props.groupTypes.indexOf('TeamGroup') is -1 or _.find(this.props.groups, (group) -> group and group.type is 'TeamGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'TeamGroup', 'TeamBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Team Members</span>`

  renderInsertContactGroup: ->
    unless this.props.groupTypes.indexOf('ContactGroup') is -1 or _.find(this.props.groups, (group) -> group and group.type is 'ContactGroup')
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'ContactGroup', 'ContactBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}}>Contact Information</span>`

  renderInsertSidebarContent: ->
    unless this.props.groupTypes.indexOf('SidebarContentGroup') is -1
      group = _.find(this.props.groups, (group) -> group and group.type is 'SidebarGroup')
      if group
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Flexible content options" data-content="Can use a small image or embedded media and text in the sidebar.">Content Block</span>`
      else
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarContentBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Flexible content options" data-content="Can use a small image or embedded media and text in the sidebar.">Content Block</span>`

  renderInsertSidebarBlogFeed: ->
    unless this.props.groupTypes.indexOf('SidebarBlogFeedGroup') is -1
      group = _.find(this.props.groups, (group) -> group and group.type is 'SidebarGroup')
      if group
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarBlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a smaller feed of content" data-content="Keep your site fresh with a small content feed (content posted separately).">Content Feed</span>`
      else
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarBlogFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a smaller feed of content" data-content="Keep your site fresh with a small content feed (content posted separately).">Content Feed</span>`

  renderInsertSidebarEventsFeed: ->
    unless this.props.groupTypes.indexOf('SidebarEventsFeedGroup') is -1
      group = _.find(this.props.groups, (group) -> group and group.type is 'SidebarGroup')
      if group and not _.find(group.blocks, (block) -> block and block.type is 'SidebarEventsFeedBlock')
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarEventsFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add an event-specific feed" data-content="Highlight upcoming events automatically showing nearest events first (content posted separately).">Event Feed</span>`
      else if not group
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarEventsFeedBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add an event-specific feed" data-content="Highlight upcoming events automatically showing nearest events first (content posted separately).">Event Feed</span>`

  renderInsertSidebarReviews: ->
    unless this.props.groupTypes.indexOf('SidebarReviewsGroup') is -1
      group = _.find(this.props.groups, (group) -> group and group.type is 'SidebarGroup')
      if group and not _.find(group.blocks, (block) -> block and block.type is 'SidebarReviewsBlock')
        `<span className="btn btn-sm btn-default" onClick={this.insertBlock.bind(null, group.uuid, 'SidebarReviewsBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a reviews widget" data-content="Keep your site fresh with a rotating reviews widget (content posted separately).">Reviews</span>`
      else if not group
        `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'SidebarGroup', 'SidebarReviewsBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a reviews widget" data-content="Keep your site fresh with a rotating reviews widget (content posted separately).">Reviews</span>`

  render: ->
    `<div className="webpage-save">
      <div className="container">
        <p className="webpage-save-toggle-on text-right"><i className="fa fa-arrow-circle-up" /> Add Page Elements</p>
        <p className="webpage-save-toggle-off pull-right" style={{ position: 'relative', zIndex: 1 }}><i className="fa fa-arrow-circle-down" /> Hide Page Options</p>
        <div className="row">
          <div className="col-sm-6">
            <p id="add_main_block_label" style={{ marginBottom: 5 }}><strong>Add Main Block</strong> <span className="text-success">{this.props.insertMainSuccessMessage}</span></p>
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
            <p id="add_sidebar_block_label" style={{ marginBottom: 5 }}><strong>Add Sidebar Block</strong> <span className="text-success">{this.props.insertSidebarSuccessMessage}</span></p>
            <div id="add_sidebar_block_options" >
              {this.renderInsertSidebarContent()}
              {this.renderInsertSidebarBlogFeed()}
              {this.renderInsertSidebarEventsFeed()}
              {this.renderInsertSidebarReviews()}
            </div>
          </div>
          <div className="col-sm-2">
            <p style={{ marginTop: 5 }}><button type="submit" className="btn btn-block btn-success">Save Changes</button></p>
          </div>
        </div>
      </div>
    </div>`

window.WebpageSave = WebpageSave
