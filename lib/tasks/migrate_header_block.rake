desc 'Migrate the header block from theme to multiple options'
task migrate_header_block: :environment do
  HeaderBlock.find_each do |block|
    case block.theme
    when 'center'
      block.update(
        logo_horizontal_position: 'left',
        logo_vertical_position: 'inside',
        navigation_horizontal_position: 'center',
      )
    when 'justify'
      block.update(
        logo_horizontal_position: 'left',
        logo_vertical_position: 'inside',
        navigation_horizontal_position: 'right',
      )
    when 'logo_above'
      block.update(
        logo_horizontal_position: 'left',
        logo_vertical_position: 'above',
        navigation_horizontal_position: 'left',
      )
    when 'logo_below'
      block.update(
        logo_horizontal_position: 'left',
        logo_vertical_position: 'below',
        navigation_horizontal_position: 'left',
      )
    when 'logo_center'
      block.update(
        logo_horizontal_position: 'center',
        logo_vertical_position: 'inside',
        navigation_horizontal_position: 'center',
      )
    when 'logo_above_full_width'
      block.update(
        logo_horizontal_position: 'left',
        logo_vertical_position: 'above',
        navigation_horizontal_position: 'left',
        navbar_location: 'static',
      )
    else
      block.update(
        logo_horizontal_position: 'left',
        logo_vertical_position: 'inside',
        navigation_horizontal_position: 'left',
      )
    end
  end
end
