class LocableManagerInvitation < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'manager_invitations'

  belongs_to :business, class_name: LocableBusiness.name, foreign_key: :business_id
  belongs_to :user, class_name: LocableUser.name, foreign_key: :user_id
end
