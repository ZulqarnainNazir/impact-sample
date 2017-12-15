WebpageSave = React.createClass
  insertGroup: (groupType, blockType) ->
    this.props.insertGroup(groupType, blockType)

  insertBlock: (groupId, blockType) ->
    this.props.insertBlock(groupId, blockType)

  onSave: (event) ->
    $btn = $(event.target)
    $btn.addClass('disabled')
    setTimeout(this.enableButton.bind(null, $btn), 2000)

  enableButton: (btn) ->
    btn.removeClass('disabled')

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

  renderInsertCalendarGroup: ->
    unless this.props.groupTypes.indexOf('CalendarGroup') is -1
      `<span className="btn btn-sm btn-default" onClick={this.insertGroup.bind(null, 'CalendarGroup', 'CalendarBlock')} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Add a calendar" data-content="Keep your site fresh with a large calendar event feed (content posted separately).">Calendar</span>`

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

  renderDataFeedButton: ->
    unless this.props.groupTypes.indexOf('BlogFeedGroup') is -1 ||
           this.props.groupTypes.indexOf('ReviewsGroup') is -1 ||
           this.props.groupTypes.indexOf('SupportLocalGroup') is -1 ||
           this.props.groupTypes.indexOf('ContactFormGroup') is -1 ||
           this.props.groupTypes.indexOf('CalendarGroup') is -1

      `<span className="btn btn-sm btn-default" onClick={this.props.showFeedContentModal} style={{marginRight: '0.3em', marginBottom: '0.3em'}} title="Choose and configure dynamic content" data-content="Incorporate content feeds, forms, reviews, and your SupportLocal Network.">
        Feed Content
      </span>`

  render: ->
    `<div className="webpage-save">
      <div className="container">
        <p className="webpage-save-toggle-on text-right"><i className="fa fa-arrow-circle-up" /> Add Page Elements</p>
        <p className="webpage-save-toggle-off pull-right" style={{ position: 'relative', zIndex: 1 }}><i className="fa fa-arrow-circle-down" /> Hide Page Options</p>
        <div className="row">
          <div className="col-sm-6 col-sm-offset-1">
            <p id="add_main_block_label" style={{ marginBottom: 5 }}><strong>Add Blocks to Page</strong> <span className="text-success">{this.props.insertMainSuccessMessage}</span></p>
            <div id="add_main_block_options">
              {this.renderInsertHeroGroup()}
              {this.renderInsertTaglineGroup()}
              {this.renderInsertCallToActionGroup()}
              {this.renderInsertContentGroup()}
              {this.renderInsertAboutGroup()}
              {this.renderInsertTeamGroup()}
              {this.renderInsertContactGroup()}
              {this.renderDataFeedButton()}
            </div>
          </div>
          <div className="col-sm-3">
            <p style={{ marginTop: 5 }}><button type="submit" className="btn btn-block btn-success save-btn" onClick={this.onSave}>Save Changes</button></p>
          </div>
        </div>
      </div>
    </div>`

window.WebpageSave = WebpageSave
