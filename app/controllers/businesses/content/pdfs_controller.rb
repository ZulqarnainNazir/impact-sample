class Businesses::Content::PdfsController < Businesses::Content::BaseController
  def index
    if current_user.businesses.count > 1 || current_user.super_user?
      params[:local] ||= 'true'
    else
      params[:local] = 'true'
    end

    if params[:local] == 'true'
      # binding.pry
      @business = Business.find(params['business_id'])
      @pdfs = Pdf.where(business_id: @business.id).order(created_at: :desc).page(params[:page]).per(48)
    else
      @pdfs = Pdf.where('business_id = ? OR user_id = ?', @business.id, current_user.id).order(created_at: :desc).page(params[:page]).per(48)
    end
  end

  def new
    @business = Business.find(params['business_id'])
    @pdf = Pdf.new
  end

  def create
    binding.pry
    update_resource @pdf, pdf_params
  end


  private

  def pdf_params
    params.require(:pdf).permit(
      :file_name,
      :file_size,
    )
  end
end
