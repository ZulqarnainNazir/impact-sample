Image = React.createClass
  propTypes:
    alt: React.PropTypes.string
    src: React.PropTypes.string
    title: React.PropTypes.string

  render: ->
    `<img src={this.props.src} alt={this.props.alt} title={this.props.title} />`

window.Image = Image
