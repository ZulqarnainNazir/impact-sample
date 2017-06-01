class AddTypeOfToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :type_of, :string
  end
end
