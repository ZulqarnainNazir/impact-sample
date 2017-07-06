class Super::UsersController < SuperController
  layout 'businesses'

  def super_admins
    @users = User.get_super_users
  end

  def all_users
	@users = User.includes(:businesses).order("id").search(params[:search], params[:constraint]) #.page(params[:page]).per(20)
  end

  private

end
