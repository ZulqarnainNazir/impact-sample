class Super::ToDoListsController < SuperController
  def index
    @to_do_lists = ToDoList.all.page(params[:page]||1).per(20)
  end

  def new
    @to_do_list = ToDoList.new
  end

  def create
    @to_do_list = ToDoList.new(to_do_list_params)

    if @to_do_list.save
      redirect_to super_to_do_lists_path, notice: 'ToDoList Added'
    else
      render :new
    end
  end

  def edit
    @to_do_list = ToDoList.find(params[:id])
  end

  def update
    @to_do_list = ToDoList.find(params[:id])

    if @to_do_list.update(to_do_list_params)
      redirect_to super_to_do_lists_path, notice: 'ToDoList Updated'
    else
      render :edit
    end
  end

  def destroy
    @to_do_list = ToDoList.find(params[:id])
    @to_do_list.destroy

    redirect_to super_to_do_lists_path, notice: 'ToDoList Deleted'
  end

  private

  def to_do_list_params
    params.require(:to_do_list).permit(:name, :description)
  end
end
