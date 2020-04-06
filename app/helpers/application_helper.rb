module ApplicationHelper
  include Recaptcha::ClientHelper
  # Render a submit button and cancel link
  # def submit_or_cancel(cancel_url = session[:return_to] ? session[:return_to] : url_for(:action => 'index'), label = 'Save Changes', submit_html_options = {})
  #   submit_html_options.merge!({ :class => "btn btn-primary" })
  #   raw(content_tag(:div, submit_tag(label, submit_html_options) + ' or ' +
  #     link_to('Cancel', cancel_url), :id => 'submit_or_cancel', :class => 'submit'))
  # end
  def share_authorized?(business)
     business.facebook_token?
  end

  def listing_path(business)
    business.generate_listing_path
  end

  def listing_review_path(business, review)
    business.generate_listing_path + "/reviews/#{review.to_param}"
  end

  def listing_directory_path(business, directory)
    business.generate_listing_path + "/directories/#{directory.to_param}"
  end

  def listing_event_path(business, event)
    business.generate_listing_path + "/event/#{event.to_param}"
  end

  def listing_content_type_path(business, content, content_type)
    business.generate_listing_path + "/#{content}?content=#{content_type}"
  end

  def listing_before_after_path(business, content)
    business.generate_listing_path + "/before_after/#{content}/"
  end

  def listing_offer_path(business, content)
    business.generate_listing_path + "/offer/#{content}/"
  end

  def listing_post_path(business, content)
    business.generate_listing_path + "/post/#{content}/"
  end

  def listing_job_path(business, content)
    business.generate_listing_path + "/job/#{content}/"
  end

  def listing_quick_post_path(business, content)
    business.generate_listing_path + "/quick_post/#{content}/"
  end


  def listing_path_url(business)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}"
  end

  def listing_path_url_with_segment(business)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_segment}"
  end

  def listing_path_content_url(business, content, content_type)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/#{content}?content=#{content_type}"
  end

  def listing_path_review_url(business, review)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/reviews/show/#{review.to_param}"
  end

  def listing_path_product_url(business, product)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/products/#{product.to_param}"
  end

  def listing_path_checkout_session_url(business)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/checkout_session"
  end

  def listing_path_checkout_url(business)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/checkout"
  end

  def listing_path_calendar_url(business, calendar)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/calendars/#{calendar.to_param}"
  end

  def listing_path_directory_url(business, directory)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/directories/#{directory.to_param}"
  end

  def listing_path_event_url(business, event)
    "http://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/events/show/#{event.to_param}"
  end

  def listing_path_new_review_url(business, score, token)
    "https://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/reviews/new?feedback_score=#{score}&feedback_token=#{token}"
  end

  def shared?(post, business)
    post.facebook_id? && business.facebook_token?
  end

  def submit_or_cancel_back_to_root(cancel_url = session[:return_to] ? session[:return_to] : url_for(:action => 'index'), label = 'Save Changes', submit_html_options = {})
    submit_html_options.merge!({ :class => "btn btn-primary" })
    raw(content_tag(:div, submit_tag(label, submit_html_options) + ' or ' +
      link_to('Cancel', root_path), :id => 'submit_or_cancel', :class => 'submit'))
  end

  def submit_or_cancel_back_to_initial_plan(cancel_url = session[:return_to] ? session[:return_to] : url_for(:action => 'index'), label = 'Save Changes', submit_html_options = {})
    submit_html_options.merge!({ :class => "btn btn-primary" })
    raw(content_tag(:div, submit_tag(label, submit_html_options) + ' or ' +
      link_to('Cancel', initial_plan_setup_business_subscriptions_path), :id => 'submit_or_cancel', :class => 'submit'))
  end

  def submit_or_cancel_back_to_new_website(cancel_url = session[:return_to] ? session[:return_to] : url_for(:action => 'new_website'), label = 'Save Changes', submit_html_options = {})
    submit_html_options.merge!({ :class => "btn btn-primary" })
    raw(content_tag(:div, submit_tag(label, submit_html_options) + ' or ' +
      link_to('Cancel', new_website_business_website_add_website_path), :id => 'submit_or_cancel', :class => 'submit'))
  end

  def submit_or_cancel_back_to_plan(cancel_url = session[:return_to] ? session[:return_to] : url_for(:action => 'index'), label = 'Save Changes', submit_html_options = {})
    submit_html_options.merge!({ :class => "btn btn-primary" })
    raw(content_tag(:div, submit_tag(label, submit_html_options) + ' or ' +
      link_to('Cancel', plan_business_subscriptions_path), :id => 'submit_or_cancel', :class => 'submit'))
  end

  def submit_or_cancel_back_to_dashboard(cancel_url = session[:return_to] ? session[:return_to] : url_for(:action => 'index'), label = 'Save Changes', submit_html_options = {})
    submit_html_options.merge!({ :class => "btn btn-primary" })
    raw(content_tag(:div, submit_tag(label, submit_html_options) + ' or ' +
      link_to('Cancel', subscription_dashboard_business_subscriptions_path), :id => 'submit_or_cancel', :class => 'submit'))
  end

  def post_to_create_or_to_plan
    #this method will direct a user to the create resource in subscription_controller,
    #or to the plan resource (which updates/upgrades plans), dependent on whether or not
    #they have a subscription already in place or not.
    business = Business.find(params[:business_id])
    if !business.nil?
      if !business.subscription.present?
        business_subscriptions_path
      elsif business.subscription.present?
        plan_business_subscriptions_path
      end
    end
  end

  def post_to_create_or_to_plan_initial_setup
    #this method will direct a user to the create resource in subscription_controller,
    #or to the plan resource (which updates/upgrades plans), dependent on whether or not
    #they have a subscription already in place or not.
    business = Business.find(params[:business_id])
    if !business.nil?
      if !business.subscription.present?
        "create"
      elsif business.subscription.present?
        "plan"
      end
    end
  end

  def impact_url(request = nil)
    host = Rails.application.secrets.host

    if Rails.env.production?
      "https://#{host}"
    else
      "http://#{host}:#{request ? request.port : 5000}"
    end
  end
end
