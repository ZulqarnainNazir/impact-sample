class UpdateOffers < ActiveRecord::Migration
  def change
    add_column :offers, :kind, :integer, default: 0, null: false
    add_column :offers, :valid_until, :date
    add_column :offers, :offer_code, :text
    add_column :offers, :terms, :text
    add_column :offers, :coupon_content_type, :text
    add_column :offers, :coupon_file_name, :text
    add_column :offers, :coupon_file_size, :integer
    add_column :offers, :coupon_updated_at, :datetime
  end
end
