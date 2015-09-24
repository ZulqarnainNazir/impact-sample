TeamBlock = React.createClass
  render: ->
    `<div>
      <article>
        <header className="page-header">
          <h1>Our Team</h1>
        </header>
      </article>
      {this.renderInterior()}
    </div>`

  renderInterior: ->
    if this.props.theme is 'horizontal'
      this.renderHorizontal()
    else this.renderVertical()

  renderHorizontal: ->
    `<div className="team-columns row">
      {this.props.teamMembers.map(this.renderHorizontalTeamMember)}
    </div>`

  renderVertical: ->
    `<div className="team-stacked">
      {this.props.teamMembers.map(this.renderVerticalTeamMember)}
    </div>`

  renderHorizontalTeamMember: (member) ->
    `<div key={member.id} className="team-member col-sm-4">
      <p><img src={member.profile_url} alt={member.name} className="img-responsive" style={{width: '100%'}} /></p>
      <h4>{member.name}</h4>
      <p>{member.title}</p>
      <p><a href={this.mailTo(member.email)}>{member.email}</a></p>
      <ul className="list-inline">
        {this.renderTwitterProfile(member.twitter_id)}
        {this.renderLinkedinProfile(member.linkedin_id)}
      </ul>
      <div className="team-member-bio">
        <div dangerouslySetInnerHTML={{__html: member.description}} />
      </div>
    </div>`

  renderVerticalTeamMember: (member) ->
    `<div key={member.id} className="row team-member">
      <div className="col-xs-6 col-sm-2">
        <p><img src={member.profile_url} alt={member.name} className="img-responsive" style={{width: '100%'}} /></p>
      </div>
      <div className="col-xs-6 col-sm-4 col-md-3">
        <h4>{member.name}</h4>
        <p>{member.title}</p>
        <p><a href={this.mailTo(member.email)}>{member.email}</a></p>
        <ul className="list-inline">
          {this.renderTwitterProfile(member.twitter_id)}
          {this.renderLinkedinProfile(member.linkedin_id)}
        </ul>
      </div>
      <div className="col-xs-12 col-sm-6 col-md-7 team-member-bio">
        <div dangerouslySetInnerHTML={{__html: member.description}} />
      </div>
    </div>`

  renderTwitterProfile: (id) ->
    if id and id.length > 0
      url = "https://www.twitter.com/#{id}"
      `<li>
        <a href={url} target="_blank">
          <i className="fa fa-twitter-square fa-2x"></i>
        </a>
      </li>`

  renderLinkedinProfile: (id) ->
    if id and id.length > 0
      url = "https://www.linkedin.com/#{id}"
      `<li>
        <a href={url} target="_blank">
          <i className="fa fa-linkedin-square fa-2x"></i>
        </a>
      </li>`

  mailTo: (email) ->
    "mailto:#{email}"

window.TeamBlock = TeamBlock
