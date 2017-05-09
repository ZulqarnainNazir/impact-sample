class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :company_id, null: false
      t.integer :invitee_id
      t.integer :inviter_id, null: false
      t.string :message

      t.timestamps null: false
    end
  end
end
