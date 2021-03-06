class Businesses::Content::PdfsController < Businesses::Content::BaseController
  respond_to(:html, :js, :json)
  skip_before_action :verify_authenticity_token
  skip_before_action :confirm_content_activated

  def index
    @business = Business.find(params['business_id'])
    @pdfs = Pdf.where(business_id: @business.id).order(created_at: :desc).page(params[:page]).per(48)

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
        format.js { redirect_to [@business, :content_pdfs], notice: 'PDF was successfully created.' }
      else
        format.js { render :new, notice: 'PDF not created' }
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
      :attachment,
    )
  end
end
