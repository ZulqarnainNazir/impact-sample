# // import React, { PropTypes } from 'react'

GroupList = React.createClass

  componentDidMount: () ->
    $(ReactDOM.findDOMNode(this)).find('.webpage-group-popover').popover({
      container: 'body',
      placement: 'top',
      trigger: 'hover',
      delay: {
        show: 500,
        hide: 0,
      },
    })

    $('.sortable-hero-handles').sortable({
      item: '> .webpage-group-hero-switch-handle',
      tolerance: 'pointer',
      placeholder: 'hero-handle-placeholder',
    })

  webpageContainerClassName: () ->
    if (this.props.wrapContainer == 'true')
      return 'webpage-container webpage-container-wrapper'
    return 'webpage-container'

  renderFullWidthGroups: () ->
    groups = _.sortBy(_.filter(this.props.groups, (group) -> group and group.kind is 'full_width'), 'position')
    _.map groups, this.renderGroup


  renderGroup: (group) ->
    `<GroupContainer
      key={group.uuid}
      group={group}
      callbacks={this.props.callbacks}
      {...this.props.callbacks}
      webpageState={this.props.webpageState}
      {...this.props.webpageState}
    />`

  renderContainerGroups: ->
    groups = _.sortBy(_.filter(this.props.groups, (group) -> group and group.kind is 'container'), 'position')
    `<div className="webpage-wrapper">
      <div className="container">
        <div className={this.webpageContainerClassName()}>
          {_.map(groups, this.renderGroup)}
        </div>
      </div>
    </div>`

  render: () ->
    # // sorts the passed in groups according to their position property
    style = {
      position: 'relative',
      paddingTop: 1,
      paddingBottom: 1,
      backgroundColor: this.props.backgroundColor,
      color: this.props.foregroundColor,
    }
    return (
      `<div style={style}>
        {this.renderFullWidthGroups()}
        {this.renderContainerGroups()}
      </div>`
    )


GroupList.propTypes = {
  backgroundColor: React.PropTypes.string,
  foregroundColor: React.PropTypes.string,
  groups: React.PropTypes.object,
  editMedia: React.PropTypes.func,
}

# // export default GroupList

window.GroupList = GroupList
