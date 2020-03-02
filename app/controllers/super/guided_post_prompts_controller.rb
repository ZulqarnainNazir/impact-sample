class Super::GuidedPostPromptsController < SuperController

  def index
    @prompts = GuidedPostPrompt.order('post_type asc', 'industry asc', 'section_type asc').page(params[:page]||1).per(20)
  end

  def new
    # @categories = Category.alphabetical
    @prompt = GuidedPostPrompt.new
  end

  def create
    # @categories = Category.alphabetical
    @prompt = GuidedPostPrompt.new(guided_post_prompts_params)

    if @prompt.save
      redirect_to super_guided_post_prompts_path, notice: 'Prompt Added'
    else
      render :new
    end
  end

  def edit
    # @categories = Category.alphabetical
    @prompt = GuidedPostPrompt.find(params[:id])
  end

  def update
    # @categories = Category.alphabetical
    @prompt = GuidedPostPrompt.find(params[:id])

    if @prompt.update(guided_post_prompts_params)
      redirect_to super_guided_post_prompts_path, notice: 'Prompt Updated'
    else
      render :edit
    end
  end

  def destroy
    @prompt = GuidedPostPrompt.find(params[:id])
    @prompt.destroy

    redirect_to super_guided_post_prompts_path, notice: 'Prompt Deleted'
  end

  private

  def guided_post_prompts_params
    params.require(:guided_post_prompt).permit(
      :prompt,
      :description,
      :heading_prompt,
      :post_type,
      :section_type,
      :industry,
    )
  end
end
