BlockIdentifiedTabs =
  tabContentId: ->
    "tab-content-edit-#{this.props.block.key}"

  tabDesignId: ->
    "tab-design-edit-#{this.props.block.key}"

  renderBlockIdentifiedTabs: ->
    `<div className="tabpanel">
      <ul className="nav nav-tabs" role="tablist" data-tabs="tabs">
        <li role="presentation" className="active">
          <a href={"#" + this.tabContentId()} aria-content={this.tabContentId()} role="tab" data-toggle="tab">Edit Content</a>
        </li>
        <li role="presentation">
          <a href={"#" + this.tabDesignId()} aria-content={this.tabDesignId()} role="tab" data-toggle="tab">Edit Design</a>
        </li>
      </ul>
      <div className="tab-content">
        <div id={this.tabContentId()} className="tab-pane fade in active" role="tabpanel">
          {this.renderContentTab()}
        </div>
        <div id={this.tabDesignId()} className="tab-pane fade" role="tabpanel">
          {this.renderDesignTab()}
        </div>
      </div>
    </div>`

  # Provide in target classes to render content tab content.
  # renderContentTab: ->

  # Override in target classes to render design tab content.
  # renderDesignTab: ->

window.BlockIdentifiedTabs = BlockIdentifiedTabs
