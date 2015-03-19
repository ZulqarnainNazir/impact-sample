class AuthorizationCreateService
  attr_reader :business

  def initialize(business, authorization)
    @authorization = authorization
    @authorization.business = business
  end

  def assign_attributes(attributes = {})
    @authorization.assign_attributes(attributes)

    email = attributes[:user_attributes][:email].to_s rescue ''
    user = User.where(email: email.downcase).first

    if user
      @authorization.user = user
    else
      @authorization.user.tap do |user|
        def user.password_required?
          false
        end
      end
    end
  end

  def save(*args)
    @authorization.save(*args)
  end
end
