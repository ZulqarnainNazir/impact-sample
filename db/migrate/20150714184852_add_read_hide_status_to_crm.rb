class AddReadHideStatusToCrm < ActiveRecord::Migration
  def change
    add_column :contact_messages, :hide, :boolean, default: false, null: false
    add_column :contact_messages, :read_by, :integer, array: true, default: [], null: false
    add_column :customers, :hide, :boolean, default: false, null: false
    add_column :customers, :read_by, :integer, array: true, default: [], null: false
    add_column :feedbacks, :hide, :boolean, default: false, null: false
    add_column :feedbacks, :read_by, :integer, array: true, default: [], null: false
    add_column :reviews, :hide, :boolean, default: false, null: false
    add_column :reviews, :read_by, :integer, array: true, default: [], null: false
  end
end
