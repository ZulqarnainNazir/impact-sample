class CreateAffiliatePayments < ActiveRecord::Migration
  def change
    create_table :affiliate_payments do |t|
      t.text "title"
      t.integer  "subscription_affiliate_id"
      t.integer  "subscription_payment_id"
      t.text "description"
      t.decimal  "amount",          :precision => 6,  :scale => 2, :default => 0.0
      t.boolean "paid", default: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
