class ContactSchema
  extend Conformist

  column :first_name, 0
  column :last_name, 1
  column :email, 2
  column :phone, 3
  column :street1, 4
  column :street2, 5
  column :city, 6
  column :state, 7
  column :zip, 8
  column :relationship, 9 do |value|
    if !value.blank?
      value.split(",")
    else
      []
    end
  end
  column :description, 10

  def self.to_hash
    columns.reduce({}) do |result, column|
      result.merge column.name => column.indexes.first
    end
  end

  def self.remap(csv, mapping)
    CSV.generate do |result|
      csv.each_with_index do |row, index|
        [].tap do |new_row|
          valid_mapping = mapping.reject{ |k, v| v.blank? }
          valid_mapping.each do |csv_order, schema_order|
            new_row[schema_order.to_i] = row[csv_order.to_i]
          end
          result << new_row
        end
      end
    end
  end
end
