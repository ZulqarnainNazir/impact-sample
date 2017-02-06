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
end
