ThemeTeamHorizontalDesigner = React.createClass
  propTypes:
    teamMembers: React.PropTypes.array

  render: ->
    `<div>
      <div className="container">
        <article>
          <header className="page-header">
            <h1>Our Team</h1>
          </header>
        </article>
      </div>
      <div className="container">
        <div className="team-columns row">
          {this.props.teamMembers.map(this.renderTeamMember)}
        </div>
      </div>
    </div>`

  renderTeamMember: (member) ->
    `<div key={member.id} className="team-member col-sm-4">
      <p><img src={member.large_profile_url} alt={member.name} className="img-responsive" style={{width: '100%'}} /></p>
      <h4>{member.name}</h4>
      <p>{member.title}</p>
      <p><a href={this.mailTo(member.email)}>{member.email}</a></p>
      <ul className="list-inline">
        {this.renderTwitterProfile(member.twitter_id)}
        {this.renderLinkedinProfile(member.linkedin_id)}
      </ul>
      <div className="team-member-bio">
        <p>{member.description}</p>
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
      url = "https://www.linkedin.com/in/#{id}"
      `<li>
        <a href={url} target="_blank">
          <i className="fa fa-linkedin-square fa-2x"></i>
        </a>
      </li>`

  mailTo: (email) ->
    "mailto:#{email}"

window.ThemeTeamHorizontalDesigner = ThemeTeamHorizontalDesigner
