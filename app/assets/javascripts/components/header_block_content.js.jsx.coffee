HeaderBlockContent = React.createClass
  render: ->
    switch this.props.theme
      when 'center'             then `<ThemeHeaderCenterDesigner              {...this.props} />`
      when 'justify'            then `<ThemeHeaderJustifyDesigner             {...this.props} />`
      when 'logo_above'          then `<ThemeHeaderLogoAboveDesigner           {...this.props} />`
      when 'logo_above_full_width' then `<ThemeHeaderLogoAboveFullWidthDesigner  {...this.props} />`
      when 'logo_below'          then `<ThemeHeaderLogoBelowDesigner           {...this.props} />`
      when 'logo_center'         then `<ThemeHeaderLogoCenterDesigner          {...this.props} />`
      else                           `<ThemeHeaderInlineDesigner              {...this.props} />`

window.HeaderBlockContent = HeaderBlockContent
