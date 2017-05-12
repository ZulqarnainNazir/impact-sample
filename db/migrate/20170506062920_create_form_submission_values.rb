class CreateFormSubmissionValues < ActiveRecord::Migration
  def change
    create_table :form_submission_values do |t|
      t.references :form_submission, index: true
      t.references :contact_form_form_field, index: true
      t.string :value

      t.timestamps null: false
    end
  end
end
