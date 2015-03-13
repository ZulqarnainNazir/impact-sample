class Devise::CustomConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :authenticate_user!

  def update
    with_unconfirmed_confirmable do
      if @confirmable.encrypted_password?
        @confirmable.errors.add(:email, :password_already_set)
      else
        @confirmable.update_attributes(user_params)
        if @confirmable.valid?
          do_confirm
        else
          do_show
          @confirmable.errors.clear
        end
      end
    end

    if !@confirmable.errors.empty?
      render 'devise/confirmations/new'
    end
  end

  def show
    with_unconfirmed_confirmable do
      if @confirmable.encrypted_password?
        do_confirm
      else
        do_show
      end
    end
    if !@confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new'
    end
  end

  protected

  def with_unconfirmed_confirmable
    original_token = params[:confirmation_token]
    confirmation_token = Devise.token_generator.digest(User, :confirmation_token, original_token)
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
    if !@confirmable.new_record?
      @confirmable.send(:pending_any_confirmation) {yield}
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'devise/confirmations/show'
  end

  def do_confirm
    @confirmable.confirm!
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
    )
  end
end
