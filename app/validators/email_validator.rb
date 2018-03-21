class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    puts "**** EMAIL VALIDATOR ****"
    puts record
    puts attribute
    puts value
    m = ValidEmail2::Address.new(value)
    unless m.valid? && m.valid_mx? && !m.disposable? && !m.blacklisted?
      puts (options[:message] || "is not valid")
      record.errors[attribute] << (options[:message] || "is invalid")
    else
      puts "Email Validator: Seems valid to me"
    end
  end
end
