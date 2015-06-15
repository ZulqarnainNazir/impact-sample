class AddPhoneToContactMessages < ActiveRecord::Migration
  def change
    add_column :contact_messages, :phone, :text
  end
end
