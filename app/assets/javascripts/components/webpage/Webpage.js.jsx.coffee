
# // top level WebPage component that is responsible for rendering webpage
# // content & the UI for the web builder
Webpage = React.createClass
  propTypes:
    backgroundColor: React.PropTypes.string,
    browserButtonsSrc: React.PropTypes.string,
    bulkUploadPath: React.PropTypes.string,
    foregroundColor: React.PropTypes.string,
    groupTypes: React.PropTypes.array,
    groups: React.PropTypes.object,
    hasMultipleBusinesses: React.PropTypes.bool,
    imagesPath: React.PropTypes.string,
    internalWebpages: React.PropTypes.array,
    linkColor: React.PropTypes.string,
    presignedPost: React.PropTypes.object,
    showOnlyLocalMediaLibraryOption: React.PropTypes.bool,
    sidebarPosition: React.PropTypes.string,

  renderRemovedGroupsInputs: ->
    for group in this.props.removedGroups
      destroyName = "groups_attributes[#{group.index}][_destroy]"
      idName = "groups_attributes[#{group.index}][id]"
      `<div key={group.index}>
        <input type="hidden" name={destroyName} value="1" />
        <input type="hidden" name={idName} value={group.id} />
      </div>`

  render: () ->
    `<div>
      <style dangerouslySetInnerHTML={{ __html: '.webpage-block-content a { color: ' + this.props.linkColor + '; }'}} />
      <div className="webpage-fields">
        <input type="hidden" name="sidebar_position" value={this.props.sidebarPosition} />
        {this.renderRemovedGroupsInputs()}
      </div>

      <BrowserPanel browserButtonsSrc={this.props.browserButtonsSrc}>
        <GroupList
          callbacks={this.props.callbacks}
          {...this.props.callbacks}
          webpageState={this.props.webpageState}
          {...this.props.webpageState}
        />

        <div className="panel-footer clearfix">
          <p className="checkbox pull-right" style={{ margin: 0 }}>
            <label>
              <input type="checkbox" checked={this.props.editing} onChange={this.props.toggleEditing} />
              Display Editing Dialogs?
            </label>
          </p>
        </div>
      </BrowserPanel>

      <ModalsContainer
        callbacks={this.props.callbacks}
        {...this.props.callbacks}
        webpageState={this.props.webpageState}
        {...this.props.webpageState}
      />

      <WebpageSave
        callbacks={this.props.callbacks}
        {...this.props.callbacks}
        webpageState={this.props.webpageState}
        {...this.props.webpageState}
      />

    </div>`

window.Webpage = Webpage
