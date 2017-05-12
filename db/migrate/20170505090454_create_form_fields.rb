class CreateFormFields < ActiveRecord::Migration
  def change
    create_table :form_fields do |t|
      t.string :name
      t.string :label
      t.string :contact_field

      t.timestamps null: false
    end
    FormField.create(name: "first_name", label: "First Name", contact_field: "first_name")
    FormField.create(name: "last_name", label: "Last Name", contact_field: "last_name")
    FormField.create(name: "email", label: "Email", contact_field: "email")
    FormField.create(name: "phone", label: "Phone Number", contact_field: "phone")
    FormField.create(name: "street1", label: "Address", contact_field: "street1")
    FormField.create(name: "street2", label: "Address (cont.)", contact_field: "street2")
    FormField.create(name: "city", label: "City", contact_field: "city")
    FormField.create(name: "state", label: "State", contact_field: "state")
    FormField.create(name: "zip", label: "Zip Code", contact_field: "zip")
    FormField.create(name: "business_name", label: "Business Name")
    FormField.create(name: "subject", label: "Subject")
    FormField.create(name: "message", label: "Message")
  end
end
