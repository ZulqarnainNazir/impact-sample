class LocableSubscription < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'subscriptions'

  belongs_to :subscription_plan, class_name: LocableSubscriptionPlan.name, foreign_key: :subscription_plan_id
end
