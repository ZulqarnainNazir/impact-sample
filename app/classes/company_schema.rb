class CompanySchema
  extend Conformist

  column :name, 0
  column :website_url, 1
  column :location_email, 2
  column :location_phone_number, 3
  column :location_street1, 4
  column :location_street2, 5
  column :location_city, 6
  column :location_state, 7
  column :location_zip_code, 8
  column :facebook_id, 9
  column :twitter_id, 10
  column :instagram_id, 11
  column :category_ids, 12 do |value|
    if !value.blank?
      value.split(",")
    else
      []
    end
  end
  column :description, 13

  def self.to_hash
    columns.reduce({}) do |result, column|
      result.merge column.name.to_s.sub('location_', '').to_sym => column.indexes.first
    end
  end

  def self.remap(csv, mapping)
    [].tap do |result|
      csv.each_with_index do |row, index|
        [].tap do |new_row|
          valid_mapping = mapping.reject{ |k, v| v.blank? }
          valid_mapping.each do |csv_order, schema_order|
            new_row[schema_order.to_i] = row[csv_order.to_i]
          end
          result << new_row.join(',')
        end
      end
    end
  end
end
