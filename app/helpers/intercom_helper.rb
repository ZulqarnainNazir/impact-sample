module IntercomHelper
  def intercom_tag
    return unless ENV['INTERCOM_ID'].present?

    settings = {
      app_id: ENV['INTERCOM_ID'],
      app_name: 'IMPACT',
    }

    if current_user
      settings.merge!(
        first_name: current_user.first_name,
        last_name: current_user.last_name,
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
        linked_facebook_page: current_user.businesses.any? { |business| business.facebook_id? && business.facebook_token? },

        sent_invite: current_user.invites.size > 0,
        sent_member_invite: current_user.invites.where(invite_as_member: true).any?,
        received_invite: Invite.where(invitee: Contact.find_by(email: current_user.email)).any?,
        received_member_invite: Invite.where(invitee: Contact.find_by(email: current_user.email), invite_as_member: true).any?,

        created_reviews_widget: current_user.businesses.any? { |b| !b.review_widgets.empty? },
        created_directory_widget: current_user.businesses.any? { |b| !b.directory_widgets.empty? },
        created_custom_marketing_mission: MissionInstance.where(creating_user: current_user).any?,

        assigned_marketing_mission: MissionInstance.where(assigned_user: current_user).any?,
        created_todo_list: current_user.businesses.any? { |b| !b.to_do_lists.empty? },
        activated_marketing_mission: MissionHistory.where(actor: current_user, action: "activated"),
        added_contact: current_user.businesses.any? { |b| !b.contacts.empty? },
        added_company: current_user.businesses.any? { |b| !b.owned_companies.empty? },
        has_todos_enabled: current_user.businesses.any?(&:to_dos_enabled?),
        is_affiliate: current_user.businesses.any? { |b| b.is_affiliate? },
        createad_landing_page: current_user.businesses.any? do |b|
          webpages = b.website.try(:webpages)
          webpages ? !webpages.empty? : false
        end
      )
    end

    current_business = Business.find_by(id: params[:business_id])
    if current_business
      settings.merge!(
        plan: current_business.try(:subscription).try(:subscription_plan).try(:name),
        membership_org: current_business.membership_org,
        company_list_count: current_business.company_lists.size,
        people_contacts_count: current_business.contacts.size,
        company_contacts_count: current_business.owned_companies.size,
        account_id: params[:business_id],
        form_count: current_business.contact_forms.size,
        form_submissions_count: current_business.form_submissions.size,
      )
    end

    render partial: 'application/intercom', locals: { settings: settings }
  end
end
