json.browserButtonsSrc image_path('browser-buttons.png')

json.initialHeaderBlock website.header_block.try(:react_attributes, business)
json.initialFooterBlock website.footer_block.try(:react_attributes, business)

json.defaultHeaderBlockAttributes website.default_header_block_attributes(business)
json.defaultFooterBlockAttributes website.default_footer_block_attributes(business)
