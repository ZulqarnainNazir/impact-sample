module IntercomHelper
  def intercom_tag
    return unless ENV['INTERCOM_ID'].present?

    settings = {
      app_id: ENV['INTERCOM_ID'],
      app_name: 'IMPACT',
    }

    if current_user
      settings.merge!(
        name: current_user.name,
        email: current_user.email,
        created_at: current_user.created_at.to_i,
        last_sign_in_at: current_user.last_sign_in_at.to_i,
        last_url_visited: url_for(url_options),
        app_marketing_reminders: current_user.app_marketing_reminders,
        email_marketing_reminders: current_user.email_marketing_reminders,
        owned_free_businesses: current_user.owned_businesses.free.count,
        owned_web_businesses: current_user.owned_businesses.web.count,
        owned_primary_businesses: current_user.owned_businesses.primary.count,
        managed_businesses: current_user.managed_businesses.count,
        custom_primary_domain_in_use: current_user.businesses.any? { |business| business.website && business.website.webhosts.any? },
        invited_any_managers: current_user.owned_businesses.any? { |business| business.managers.any? },
      )
    end

    render partial: 'application/intercom', locals: { settings: settings }
  end
end
