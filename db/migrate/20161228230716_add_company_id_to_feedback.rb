class AddCompanyIdToFeedback < ActiveRecord::Migration
  def change
    add_reference :feedbacks, :company, index: true
  end
end
