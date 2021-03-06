class Businesses::Tools::DirectoryWidgetsController < Businesses::BaseController
  #before_action -> { confirm_module_activated(2) }
  before_action only: member_actions do
    @directory_widget = @business.directory_widgets.find(params[:id])
  end

  def new
    @directory_widget = @business.directory_widgets.new
  end

  def index
    fix_widgets = @business.directory_widgets.where( company_list_id: nil )
    if fix_widgets.any?
      @business.company_lists.create(name: "Company List 1") if @business.company_lists.empty?
      fix_widgets.each do |widget|
        widget.company_list = @business.company_lists.first
        widget.save
      end
    end

    scope = @business.directory_widgets
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where('name ILIKE ?', "%#{query}%")
    end

    @directory_widgets = scope.page(params[:page]).per(20)
  end

  def create
    @directory_widget = @business.directory_widgets.new
    create_resource @directory_widget, directory_widget_params, location: [:edit, @business, :tools, @directory_widget]
  end

  def update
    directory_widget = @business.directory_widgets.find(params[:id])
    if directory_widget.update_attributes(directory_widget_params)
      redirect_to [:edit, @business, :tools, @directory_widget], :flash => { :notice => "Widget Saved Successfully" }
    else
      render 'edit'
    end
  end

  def destroy
    DirectoryWidget.destroy(@directory_widget.id)
    redirect_to [@business, :tools_directory_widgets]
  end

  private

  def directory_widget_params
    params.require(:directory_widget).permit(:name, :enable_search, :public_label, :background_color, :company_list_id)
  end

end
