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

  def create(impact_business, impact_user, locable_site)
    raise ArgumentError, 'only new businesses can be created from persisted businesses' if persisted? || impact_business.new_record?

    begin
      Business.transaction do
        LocableBusiness.transaction do
        end
      end
      true
    rescue
      false
    end
  end

  def claim(impact_business, impact_user)
    raise ArgumentError, 'businesses must be persisted and unclaimed to claim' if new_record? || claimed? || impact_business.new_record?

    begin
      Business.transaction do
        LocableBusiness.transaction do
        end
      end
      true
    rescue
      false
    end
  end

  def link(impact_business)
    raise ArgumentError, 'businesses must be persisted and claimed to link' if new_record? || !claimed? || impact_business.new_record?

    begin
      Business.transaction do
        LocableBusiness.transaction do
          update! impact_id: impact_business.id
          impact_business.update! cce_id: id, automated_export_locable_events: nil, automated_import_locable_events: nil, automated_import_locable_reviews: nil
        end
      end
      true
    rescue
      false
    end
  end

  def unlink(impact_business)
    raise ArgumentError, 'businesses must be persisted and claimed to unlink' if new_record? || !claimed? || impact_business.new_record?

    begin
      Business.transaction do
        LocableBusiness.transaction do
          update! impact_id: nil
          impact_business.update! cce_id: nil, automated_export_locable_events: nil, automated_import_locable_events: nil, automated_import_locable_reviews: nil
        end
      end
      true
    rescue
      false
    end
  end
end
