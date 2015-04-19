class Businesses::Content::PostsController < Businesses::Content::BaseController
  before_action only: new_actions do
    @post = @business.posts.new
  end

  before_action only: member_actions do
    @post = @business.posts.find(params[:id])
  end

  def create
    create_resource @post, post_params, location: [@business, :content_feed]
  end

  def update
    update_resource @post, post_params, location: [@business, :content_feed]
  end

  def destroy
    destroy_resource @post, location: [@business, :content_feed]
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :description,
    )
  end
end
