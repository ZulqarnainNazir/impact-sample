class MakeFacebookShare
    include ActionView::Helpers::TextHelper
    attr_accessor :business, :post, :share, :klass

	def initialize(opts = {})
	  @business = Business.try(:find_by_id, opts[:business_id])
	  @klass = opts[:klass] 
	  @post = @klass.try(:find_by_id, opts[:post_id]) 
	  @share = Share.try(:find_by_id, opts[:share_id]) 
	  @page_graph = Koala::Facebook::API.new(@business.facebook_token)
	end

	def share_post
	   result = @page_graph.put_connections(@business.facebook_id, 'feed', facebook_share_parameters)
       @share.update_column :facebook_id, result['id']
       @post.update_column :facebook_id, result['id']
	end

	def update_share
	  result = @page_graph.put_connections(@post.facebook_id, facebook_share_parameters) 
      @share.update_column :facebook_id, result['id']
      @post.update_column :facebook_id, result['id']
    end

    def destroy_shares(shares)
      shares.each do |share|
        @page_graph.delete_object(share.facebook_id)
      end
    end

	def facebook_share_parameters
		   {
	        created_time: DateTime.now,
	        caption: truncate(Sanitize.fragment(@post.description, Sanitize::Config::DEFAULT), length: 1000),
	        link:@post.share_callback_url,
	        message: @share.message,
	        name: @post.title,
	        picture:  @post.share_image_url,
	        published: true
	      }
    end
end