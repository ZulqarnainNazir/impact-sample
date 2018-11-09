module ExternalUrlHelper

  def path_to_external_content(content_type)
  	args = content_type.to_generic_param_two.each {|n| n.to_s}
  	args.map { |arg| arg.gsub(%r{^/*(.*?)/*$}, '\1') }.join("/")
  end

  def url_to_external_site(business, content_type)

  	args = content_type.to_generic_param_two.each {|n| n.to_s}

  	# args.unshift(website_host(business.website))

  	#'http://www.' +
  	(website_host(business.website) + '/') + (args.map { |arg| arg.gsub(%r{^/*(.*?)/*$}, '\1') }.join("/"))
  end

  def url_with_http(url)
    # url.start_with?('http://') ? url : "http://#{url}"

    if url.start_with?('http://')
      url
    elsif url.start_with?('https://')
      url
    else
      "http://#{url}"
    end

  end

end
