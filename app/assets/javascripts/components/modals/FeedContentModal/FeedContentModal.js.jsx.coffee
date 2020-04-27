# // import React, { PropTypes } from 'react';

FeedContentModal = React.createClass
  getInitialState: ->
    choice: null
    choice_mapping: {
      'reviews': { group: 'ReviewsGroup', block: 'ReviewsBlock', editFunc: reviewHelpers.editReviewsSettings },
      'content-feed': { group: 'BlogFeedGroup', block: 'BlogFeedBlock', editFunc: feedHelpers.editFeedSettings },
      'local-network': { group: 'SupportLocalGroup', block: 'SupportLocalBlock', editFunc: supportLocalHelpers.editSupportLocalSettings },
      'contact-form': { group: 'ContactFormGroup', block: 'ContactFormBlock', editFunc: contactFormHelpers.editContactFormSettings },
      'calendar': { group: 'CalendarGroup', block: 'CalendarBlock', editFunc: calendarHelpers.editCalendarSettings },
      'mercantile': { group: 'MercantileGroup', block: 'MercantileBlock', editFunc: mercantileHelpers.editMercantileSettings },
    }

  chooseReviews: (e) ->
    e.preventDefault()
    this.updateChoice('reviews')

  chooseContentFeed: (e) ->
    e.preventDefault()
    this.updateChoice('content-feed')

  chooseLocalNetwork: (e) ->
    e.preventDefault()
    this.updateChoice('local-network')

  chooseContactForm: (e) ->
    e.preventDefault()
    this.updateChoice('contact-form')

  chooseCalendar: (e) ->
    e.preventDefault()
    this.updateChoice('calendar')

  chooseMercantile: (e) ->
    e.preventDefault()
    this.updateChoice('mercantile')

  choiceColor: (choice) ->
    if this.state.selected == choice
      return '#1ab394'
    else
      return '#676a6c'

  updateChoice: (choice) ->
    this.setState({ selected: choice })

  groupInsertCallback: (a, b, c) ->
    mapping = this.state.choice_mapping[this.state.selected]

    groupKeys = Object.keys(this.props.groups)
    groupKey  = groupKeys[groupKeys.length - 1]
    group     = this.props.groups[groupKey]
    blockKey  = Object.keys(group.blocks)[0]
    block     = group.blocks[blockKey]

    mapping.editFunc(group.uuid, block)

  saveChoice: ->
    mapping = this.state.choice_mapping[this.state.selected]
    unless this.props.groupTypes.indexOf(mapping.group) is -1
      this.props.insertGroup(mapping.group, mapping.block, this.groupInsertCallback)

  render: ->
    `<div id="feed_content_modal" className="modal fade">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <span className="close" data-dismiss="modal">&times;</span>
            <p className="h4 modal-title">Choose The Feed Type You'd Like to Use</p>
          </div>
          <div className="modal-body" style={{height: '325px'}}>
            <h2 className="m-b-lg">Pick the type of content then you can configure it</h2>
            <div className="col-sm-4 m-b-sm">
                <a href="#" onClick={this.chooseReviews} style={{color: this.choiceColor('reviews')}}>
                  <div className="review-stars text-center">
                      <div className="text-center">
                        <i className="fa fa-star fa-2x"></i>
                        <i className="fa fa-star fa-2x"></i>
                        <i className="fa fa-star fa-2x"></i>
                      </div>
                      <div className="text-center">
                        <i className="fa fa-star fa-2x"></i>
                        <i className="fa fa-star fa-2x"></i>
                      </div>
                      <h3 className="">Customer Reviews</h3>
                  </div>
                </a>
            </div>
            <div className="col-sm-4 m-b-sm">
              <a href="#" onClick={this.chooseContentFeed} style={{color: this.choiceColor('content-feed')}}>
                <div className="review-stars text-center">
                  <i className="fa fa-bullhorn fa-4x"></i>
                  <h3>Content / Blog Feed</h3>
                </div>
              </a>
            </div>
            <div className="col-sm-4 m-b-sm">
              <a href="#" onClick={this.chooseLocalNetwork} style={{color: this.choiceColor('local-network')}}>
                <div className="review-stars text-center">
                  <i className="fa fa-group fa-4x"></i>
                  <h3>SupportLocal Network</h3>
                </div>
              </a>
            </div>
            <div className="col-sm-4 m-b-sm">
              <a href="#" onClick={this.chooseContactForm} style={{color: this.choiceColor('contact-form')}}>
                <div className="review-stars text-center">
                  <i className="fa fa-address-card fa-4x"></i>
                  <h3>Contact Form</h3>
                </div>
              </a>
            </div>
            <div className="col-sm-4 m-b-sm">
              <a href="#" onClick={this.chooseCalendar} style={{color: this.choiceColor('calendar')}}>
                <div className="review-stars text-center">
                  <i className="fa fa-calendar fa-4x"></i>
                  <h3>Calendar</h3>
                </div>
              </a>
            </div>
            <div className="col-sm-4 m-b-sm" hidden={!this.props.mercantileEnabled}>
              <a href="#" onClick={this.chooseMercantile} style={{color: this.choiceColor('mercantile')}}>
                <div className="review-stars text-center">
                  <i className="fa fa-shopping-bag fa-4x"></i>
                  <h3>Mercantile</h3>
                </div>
              </a>
            </div>
        </div>
          <div className="modal-footer">
            <span className="btn btn-default" data-dismiss="modal">Cancel</span>
            <span className="btn btn-primary" data-dismiss="modal" onClick={this.saveChoice}>
              Next
            </span>
          </div>
        </div>
      </div>
    </div>`

window.FeedContentModal = FeedContentModal
