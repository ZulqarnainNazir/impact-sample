class AddCompanyIdToReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :company, index: true
  end
end
