FooterBlockContent = React.createClass
  render: ->
    switch this.props.theme
      when 'simple_full_width'             then `<ThemeFooterSimpleFullWidthDesigner              {...this.props} />`
      when 'columns'            then `<ThemeFooterColumnsDesigner             {...this.props} />`
      when 'layers'          then `<ThemeFooterLayersDesigner           {...this.props} />`
      else                           `<ThemeFooterSimpleDesigner              {...this.props} />`

window.FooterBlockContent = FooterBlockContent
