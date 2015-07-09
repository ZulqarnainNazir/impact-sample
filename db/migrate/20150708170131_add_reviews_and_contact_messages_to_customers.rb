class AddReviewsAndContactMessagesToCustomers < ActiveRecord::Migration
  def change
    remove_column :reviews, :external_user_id, :text
    remove_column :reviews, :external_user_name, :text
    change_column_null :reviews, :external_id, true
    change_column_null :reviews, :external_name, true
    change_column_null :reviews, :external_type, true
    change_column_null :reviews, :external_url, true
    rename_column :reviews, :rating, :overall_rating
    add_column :reviews, :quality_rating, :decimal, precision: 2, scale: 1
    add_column :reviews, :service_rating, :decimal, precision: 2, scale: 1
    add_column :reviews, :value_rating, :decimal, precision: 2, scale: 1
    add_column :reviews, :customer_name, :text
    add_column :reviews, :customer_email, :text
    add_column :reviews, :customer_phone, :text
    add_column :reviews, :customer_id, :integer
    add_column :reviews, :published, :boolean, default: false, null: false
    add_column :reviews, :serviced_at, :date
    add_index :reviews, :customer_id

    rename_column :contact_messages, :name, :customer_name
    rename_column :contact_messages, :email, :customer_email
    rename_column :contact_messages, :phone, :customer_phone
    add_column :contact_messages, :customer_id, :integer
    add_index :contact_messages, :customer_id
  end
end
