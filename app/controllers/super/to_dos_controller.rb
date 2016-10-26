class Super::ToDosController < SuperController
  def index
    @businesses = Business.includes(:to_dos).where(to_dos_enabled: true).page(params[:page]||1).per(20)
  end
end
