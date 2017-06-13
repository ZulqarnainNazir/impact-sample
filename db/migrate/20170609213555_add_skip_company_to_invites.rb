class AddSkipCompanyToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :skip_company, :boolean, default: false
    change_column :invites, :company_id, :integer, :null => true
  end
end
