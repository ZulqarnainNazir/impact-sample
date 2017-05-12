class AddReadByAndToFormSubmissions < ActiveRecord::Migration
  def change
    add_column :form_submissions, :read_by, :integer, array: true, default: [], null: false
  end
end
