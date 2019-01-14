# class CommunitiesController < ApplicationController
class Super::CommunitiesController < SuperController
  before_action :set_community, only: [:edit, :update, :destroy]
  layout 'businesses'
  # GET /communities
  # GET /communities.json
  def index
    @communities = Community.all
  end

  # GET /communities/1
  # GET /communities/1.json
  # def show
  # end

  # GET /communities/new
  def new
    @community = Community.new
    # @businesses = Business.where('community_id = ?', @community)
    # @businesses = @community.businesses
  end

  # GET /communities/1/edit
  def edit
    # @businesses = Business.where('community_id = ?', @community)
    # @businesses = @community.businesses
  end

  # POST /communities
  # POST /communities.json
  def create
    @community = Community.new(community_params)

    respond_to do |format|
      if @community.save
        format.html { redirect_to super_communities_path, notice: 'Community was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /communities/1
  # PATCH/PUT /communities/1.json
  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to super_communities_path, notice: 'Community was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /communities/1
  # DELETE /communities/1.json
  def destroy
    @community.destroy
    respond_to do |format|
      format.html { redirect_to super_communities_url, notice: 'Community was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_params
      params.require(:community).permit(:label, :boundry_coordinates, community_businesses_attributes: [:id, :anchor, :champion])
    end
end
