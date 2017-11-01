class AddIndirectCreator < ActiveRecord::Migration
  def change
  	add_column :companies, :business_record_creator, :boolean, default: false
  end
end
