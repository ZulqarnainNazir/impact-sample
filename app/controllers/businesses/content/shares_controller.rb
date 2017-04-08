class Businesses::Content::SharesController < Businesses::Content::BaseController

 def new 
  @share = Share.new
  @post = find_shareable
  if @post.instance_of?(EventDefinition)
     @event_definition = @post
     @post = @post.events.first
  end
 end

  def create
  	@post = find_shareable
    @business = @post.business
    @share = @post.shares.create!(share_params)
    MakeFacebookShare.new(business_id: @business.id, post_id: @post.id, klass: @post.class, share_id: @share.id).share_post
    redirect_to business_content_root_path(@business)
  end

 private

  def share_params
  	params.require(:share).permit(:message, :shareable_type, :scheduled_times)
  end


def find_shareable
  klasses = []
  params.each do |name, value|
    if name =~ /(.+)_id$/
      klasses << $1.classify.constantize.find(value)
    end
  end
  return klasses.last unless klasses.empty?
  nil
end

end