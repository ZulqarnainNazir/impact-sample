class RemoveContactFormWidgets < ActiveRecord::Migration
  def change
    drop_table :contact_form_widgets
  end
end
