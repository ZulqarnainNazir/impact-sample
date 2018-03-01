class ToDoNotificationMailerPreview < ActionMailer::Preview
  include ActionView::Helpers::TextHelper

  def setup_preview
    unless @user = User.find_by(super_user: false)
      @user = PopulateUser.run
    end
    unless @business = @user.businesses.first
      @business = PopulateBusiness.run(@user)
    end
    @to_do = PopulateToDo.run(@business)
    @message = PopulateToDoComment.run(@to_do, @user)
  end

  def notify
    setup_preview
    ToDoNotificationMailer.notify(
      user: @user,
      business: @business,
      to_do: @to_do,
      message: @message.content
    )
  end
end
