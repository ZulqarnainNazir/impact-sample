class Businesses::Content::PdfsController < Businesses::Content::BaseController
  respond_to(:html, :js, :json)
  skip_before_action :verify_authenticity_token

  def index
    if current_user.businesses.count > 1 || current_user.super_user?
      params[:local] ||= 'true'
    else
      params[:local] = 'true'
    end
    @business = Business.find(params['business_id'])
    if params[:local] == 'true'
      @pdfs = Pdf.where(business_id: @business.id).order(created_at: :desc).page(params[:page]).per(48)
    else
      @pdfs = Pdf.where('business_id = ? OR user_id = ?', @business.id, current_user.id).order(created_at: :desc).page(params[:page]).per(48)
    end
  end

  def new
    @business = Business.find(params['business_id'])
    @pdf = @business.pdfs.new(user: current_user)
  end

  def create
    @pdf = Pdf.new(pdf_params)
    @pdf.business = Business.find(params['business_id'])
    @pdf.user = current_user
    respond_to do |format|
      if @pdf.save
        flash[:notice] = 'PDF was successfully created.'
        format.html { redirect_to [@business, :content_pdfs] }
        format.js
        format.json { render :show, status: :created, location: @pdf }
      else
        flash[:notice] = 'PDF not created - must include a file under 20 GB.'
        format.html { render :new }
        format.json { render json: @pdf.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def show
    @business = Business.find(params[:business_id])
    @pdf = Pdf.find(params[:id])
  end

  private

  def pdf_params
    params.require(:pdf).permit(
      :file_name,
      :file_size,
      :attachment,
      :attachment_file_name,
      :attachment_file_size
    )
  end
end
