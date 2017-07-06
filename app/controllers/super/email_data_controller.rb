class Super::EmailDataController < SuperController
  layout 'businesses'

  def overview
    @emails = AhoyMessage.order("sent_at DESC") #.page(params[:page]).per(20)
  end

  private

end
