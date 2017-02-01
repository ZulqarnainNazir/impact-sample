class RenameBusinessUpdateRequestIdToBusinessUpdateRequestOnBusinessLocationUpdateRequest < ActiveRecord::Migration
  def change
    rename_column :business_location_update_requests, :business_update_request_id_id, :business_update_request_id
  end
end
