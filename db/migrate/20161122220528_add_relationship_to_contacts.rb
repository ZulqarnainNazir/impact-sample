class AddRelationshipToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :relationship, :text
  end
end
