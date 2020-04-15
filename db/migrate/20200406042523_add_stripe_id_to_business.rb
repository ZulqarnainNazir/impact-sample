class AddStripeIdToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :stripe_connected_account_id, :string
    add_column :businesses, :stripe_connected_account_refresh_token, :string
  end
end
