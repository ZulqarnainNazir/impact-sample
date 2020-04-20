class Businesses::Tools::MercantileEmbedsController < Businesses::BaseController
  #before_action -> { confirm_module_activated(1) }
  before_action only: new_actions do
    @mercantile_embed = @business.mercantile_embeds.new
  end

  before_action only: member_actions do
    @mercantile_embed = @business.mercantile_embeds.find(params[:id])
  end

  def index
    scope = @business.mercantile_embeds
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where('name ILIKE ?', "%#{query}%")
    end

    @mercantile_embeds = scope.page(params[:page]).per(20)
  end

  def create
    create_resource @mercantile_embed, mercantile_embed_params, location: [:edit, @business, :tools, @mercantile_embed]
  end

  def update
    if @business.mercantile_embeds.find(params[:id]).update_attributes(mercantile_embed_params)
      redirect_to [:edit, @business, :tools, @mercantile_embed], :flash => { :notice => "Embed Saved Successfully" }
    else
      redirect_to [:edit, @business, :tools, @mercantile_embed], :flash => { :warning => "Something went wrong" }
    end
  end

  def destroy
    MercantileEmbed.destroy(@mercantile_embed.id)
    redirect_to [@business, :tools_content_feed_widgets]
  end

  private

  def mercantile_embed_params
    params.require(:mercantile_embed).permit(:name, :public_label, :max_items, :link_version, :link_id, :link_external_url,
                                                :link_label, :link_target_blank, :link_no_follow, :show_our_content, :company_list_ids => [],
                                                )
  end

end
