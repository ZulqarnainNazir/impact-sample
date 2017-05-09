module ApplicationHelper
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

  def listing_path_url(business)
    "http://#{ENV['LISTING_HOST']}#{business.generate_listing_path}"
  end


  def listing_path_url_with_segment(business)
    "http://#{ENV['LISTING_HOST']}#{business.generate_listing_segment}"
  end

  def listing_path_content_url(business, content, content_type)
    "http://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/#{content}?content=#{content_type}"
  end
  def listing_path_review_url(business, review)
    "http://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/reviews/show/#{review.to_param}"
  end

  def listing_path_new_review_url(business, score, token)
    "http://#{ENV['LISTING_HOST']}#{business.generate_listing_path}/reviews/new?feedback_score=#{score}&feedback_token=#{token}"
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

end
