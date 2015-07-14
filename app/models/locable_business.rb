class LocableBusiness < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'businesses'

  belongs_to :creator, class_name: LocableUser.name, foreign_key: :created_by_id
  belongs_to :logo, class_name: LocableResource.name, foreign_key: :logo_id
  belongs_to :owner, class_name: LocableUser.name, foreign_key: :owner_id
  belongs_to :site, class_name: LocableSite.name, foreign_key: :site_id

  has_one :address, -> { where(owner_type: 'Business') }, class_name: LocableAddress.name, foreign_key: :owner_id, foreign_type: :owner_id
  has_one :subscription, class_name: LocableSubscription.name, foreign_key: :business_id

  has_many :business_hours, class_name: LocableBusinessHour.name, foreign_key: :business_id
  has_many :business_social_media_properties, class_name: LocableBusinessSocialMediaProperty, foreign_key: :business_id
  has_many :categorizations, -> { where(categorizable_type: 'Business') }, class_name: LocableCategorization.name, foreign_key: :categorizable_id, foreign_type: :categorizable_type
  has_many :events, class_name: LocableEvent.name, foreign_key: :business_id
  has_many :manager_invitations, class_name: LocableManagerInvitation.name, foreign_key: :business_id
  has_many :resource_placements, -> { where(placer_type: 'Busienss') }, class_name: LocableResourcePlacement.name, foreign_key: :placer_id, foreign_type: :placer_type
  has_many :reviews, class_name: LocableReview.name, foreign_key: :business_id

  has_many :categories, through: :categorizations
  has_many :users, through: :manager_invitations
  has_many :images, -> { where('mime LIKE ?', '%image%') }, through: :resource_placements, source: :resource

  def claimed?
    owner && subscription && subscription.subscription_plan.plan_code != 'free'
  end

  def locable_url
    "http://#{URI.parse(site.base_url).host rescue site.domain}/businesses/#{slug}"
  end

  def create(impact_business, impact_user, locable_user, locable_site)
    begin
      raise ArgumentError unless new_record? && impact_business.persisted?

      Business.transaction do
        LocableBusiness.transaction do
          assign_attributes(
            site: locable_site,
            creator: locable_user,
            owner: locable_user,
            impact_id: impact_business.id,
            name: impact_business.name,
            description: impact_business.description,
            slug: [impact_business.location.try(:state), impact_business.location.try(:city), impact_business.name].reject(&:blank?).join('-').parameterize,
            tagline: impact_business.tagline,
            url: impact_business.website_url,
            phone: impact_business.location.try(:phone_number),
            email: impact_business.location.try(:email),
            category_ids: LocableCategory.where(site_id: nil, name: impact_business.categories.pluck(:name)).limit(1).pluck(:id),
          )
          save!
          address || build_address
          address.assign_attributes(
            street1: impact_business.location.try(:street1),
            street2: impact_business.location.try(:street2),
            city: impact_business.location.try(:city),
            state: impact_business.location.try(:state),
            postal: impact_business.location.try(:zip_code),
          )
          address.save!
          subscription || build_subscription
          subscription.coupon_code = nil
          subscription.subscription_plan = LocableSubscriptionPlan.find_by_plan_code('express')
          subscription.user = locable_user
          subscription.save!
          impact_business.update! cce_id: id, automated_export_locable_events: '1', automated_import_locable_events: '1', automated_export_locable_reviews: '1', automated_import_locable_reviews: '1'
        end
      end

      result = true
    rescue
      result = false
    end

    if result
      token = ConnectToken.encode(id: id)
      uri = URI(ENV['CONNECT_URL'] + '/complete_business_create')
      uri.query = URI.encode_www_form({ token: token })
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        true
      else
        begin
          Business.transaction do
            LocableBusiness.transaction do
              address.destroy!
              subscription.destroy!
              destroy!
              impact_business.update! cce_id: nil, automated_export_locable_events: nil, automated_import_locable_events: nil, automated_export_locable_reviews: nil, automated_import_locable_reviews: nil
            end
          end
        end

        false
      end
    end
  end

  def claim(impact_business, impact_user, locable_user)
    result = nil

    begin
      raise ArgumentError unless persisted? && !claimed? && impact_business.persisted?

      Business.transaction do
        LocableBusiness.transaction do
          update! creator: locable_user, owner: locable_user, impact_id: impact_business.id
          subscription || build_subscription
          subscription.coupon_code = nil
          subscription.subscription_plan = LocableSubscriptionPlan.find_by_plan_code('express')
          subscription.user = locable_user
          subscription.save!
          impact_business.update! cce_id: id, automated_export_locable_events: '1', automated_import_locable_events: '1', automated_export_locable_reviews: '1', automated_import_locable_reviews: '1'
        end
      end

      result = true
    rescue
      result = false
    end

    if result
      token = ConnectToken.encode(id: id)
      uri = URI(ENV['CONNECT_URL'] + '/complete_business_claim')
      uri.query = URI.encode_www_form({ token: token })
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        true
      else
        begin
          Business.transaction do
            LocableBusiness.transaction do
              update! creator: nil, owner: nil, impact_id: nil
              subscription || build_subscription
              subscription.coupon_code = nil
              subscription.subscription_plan = LocableSubscriptionPlan.find_by_plan_code('free')
              subscription.user = nil
              subscription.save!
              impact_business.update! cce_id: nil, automated_export_locable_events: nil, automated_import_locable_events: nil, automated_export_locable_reviews: nil, automated_import_locable_reviews: nil
            end
          end
        end

        false
      end
    end
  end

  def link(impact_business, impact_user, locable_user)
    begin
      raise ArgumentError unless persisted? && claimed? && impact_business.persisted? && (impact_user.super_user? || users.include?(business) || locable_user.businesses.include?(self))

      Business.transaction do
        LocableBusiness.transaction do
          update! impact_id: impact_business.id
          impact_business.update! cce_id: id, automated_export_locable_events: '1', automated_import_locable_events: '1', automated_export_locable_reviews: '1', automated_import_locable_reviews: '1'
        end
      end

      true
    rescue
      false
    end
  end

  def unlink(impact_business)
    begin
      raise ArgumentError unless persisted? && claimed? && impact_business.persisted?

      Business.transaction do
        LocableBusiness.transaction do
          update! impact_id: nil
          impact_business.update! cce_id: nil, automated_export_locable_events: nil, automated_import_locable_events: nil, automated_export_locable_reviews: nil, automated_import_locable_reviews: nil
        end
      end
      true
    rescue
      false
    end
  end
end
