EditMediaUpscaleCheckbox = React.createClass
  render: ->
    if ($('#media_type').val() != 'background')
      return (
        `<p className="small checkbox" style={{ marginTop: 10 }}>
          <label>
            <input id="media_full_width" type="checkbox" style={{ marginTop: 3 }} /> Stretch smaller images to fit full width.
          </label>
        </p>`
      )
    return `<div />`

window.EditMediaUpscaleCheckbox = EditMediaUpscaleCheckbox
