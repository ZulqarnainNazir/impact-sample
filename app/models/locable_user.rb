class LocableUser < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'users'

  has_many :businesses, class_name: LocableBusiness.name, foreign_key: :owner_id
  has_many :manager_invitations, class_name: LocableManagerInvitation.name, foreign_key: :user_id
  has_many :reviews, class_name: LocableReview.name, foreign_key: :review_id
  has_many :roles_users, class_name: LocableRolesUser, foreign_key: :user_id

  has_many :managed_businesses, class_name: LocableBusiness.name, through: :manager_invitations, source: :business
  has_many :sites, through: :roles_users

  def authenticate(password)
    token = ConnectToken.encode(email: email, password: password)
    uri = URI(ENV['CONNECT_URL'] + '/check_authentication')
    uri.query = URI.encode_www_form({ token: token })
    Net::HTTP.get_response(uri).is_a?(Net::HTTPSuccess)
  end

  def fullname
    [firstname, lastname].reject(&:blank?).join(' ')
  end

  def locable_url
    "http://#{URI.parse(site.base_url).host rescue site.domain}/connect"
  end

  def name
    fullname.present? ? fullname : 'Anonymous'
  end

  def site
    sites.joins(:roles_users).where(role_id: 2..5).order(role_id: :asc).first
  end
end
