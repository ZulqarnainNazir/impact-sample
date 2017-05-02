# // import React, { PropTypes } from 'react';

ModalsContainer = React.createClass
  render: ->
    `<div>
      <DefaultSettingsModal
        updateDefaultSettings={this.props.updateDefaultSettings}
      />
      <CustomGroupModal updateCustomGroup={this.props.updateCustomGroup} {...this.props.webpageState}/>
      <HeroSettingsModal {...this.props.callbacks} />
      <TaglineSettingsModal updateTaglineSettings={this.props.updateTaglineSettings} />
      <FeedSettingsModal {...this.props.webpageState} updateFeedSettings={this.props.updateFeedSettings} />
      <ReviewSettingsModal {...this.props.webpageState} />
      <MediaModal
        bulkUploadPath={this.props.bulkUploadPath}
        loadMediaLibraryImages={this.props.loadMediaLibraryImages}
        selectMediaLibraryImage={this.props.selectMediaLibraryImage}
        updateMedia={this.props.updateMedia}
        {...this.props.callbacks}
        {...this.props.webpageState}
      />
      <LinkModal
        resetLink={this.props.resetLink}
        updateLink={this.props.updateLink}
        {...this.props.webpageState}
      />
    </div>`

ModalsContainer.propTypes = {
  updateDefaultSettings: React.PropTypes.func.isRequired,
  loadMediaLibraryImages: React.PropTypes.func.isRequired,
}

# // export default ModalsContainer;
window.ModalsContainer = ModalsContainer