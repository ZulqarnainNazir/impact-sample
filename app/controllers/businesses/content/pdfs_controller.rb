class Businesses::Content::PdfsController < Businesses::Content::BaseController
  def index
    if current_user.businesses.count > 1 || current_user.super_user?
      params[:local] ||= 'true'
    else
      params[:local] = 'true'
    end
    @business = Business.find(params['business_id'])
    if params[:local] == 'true'
      binding.pry
      @pdfs = Pdf.where(business_id: @business.id).order(created_at: :desc).page(params[:page]).per(48)
      binding.pry
    else
      binding.pry
      @pdfs = Pdf.where('business_id = ? OR user_id = ?', @business.id, current_user.id).order(created_at: :desc).page(params[:page]).per(48)
      binding.pry
    end
  end

  def new
    @business = Business.find(params['business_id'])
    @pdf = @business.pdfs.new(user: current_user)
  end

  def create
    binding.pry
    update_resource @pdf, pdf_params
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
      :attachment
    )
  end
end
