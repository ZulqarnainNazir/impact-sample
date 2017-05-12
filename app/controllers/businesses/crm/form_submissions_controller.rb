class Businesses::Crm::FormSubmissionsController < Businesses::BaseController
  before_action only: member_actions do
    @form_submission = @business.form_submissions.find(params[:id])
    @form_submission.update_column :read_by, @form_submission.read_by + [current_user.id] unless @form_submission.read_by.include?(current_user.id)
  end

  def index
    scope = @business.form_submissions
    contact_form_id = params[:contact_form_id]

    if contact_form_id.present?
      if contact_form_id === "legacy"
        @contact_messages = @business.contact_messages.includes(:contact).where(hide: false).order(contact_messages_order).page(params[:page]).per(20)
        render 'businesses/crm/contact_messages/index'
      else
        scope = scope.where(:contact_form_id => contact_form_id)
        @contact_form = ContactForm.find(contact_form_id)
        @form_submissions = scope.page(params[:page]).per(20)
      end
    end
  end

  def show
    @form_submission = @business.form_submissions.find(params[:id])
  end

  private

  def contact_messages_order
    if %w[created_at serviced_at score].include?(params[:order_by])
      "#{params[:order_by]} #{contact_messages_order_dir} NULLS LAST"
    elsif %w[name].include?(params[:order_by])
      "contacts.#{params[:order_by]} #{contact_messages_order_dir} NULLS LAST"
    else
      'CASE WHEN cardinality(read_by) = 0 THEN 0 ELSE 1 END ASC, updated_at DESC'
    end
  end

  def contact_messages_order_dir
    if %w[asc desc].include?(params[:order_dir])
      params[:order_dir]
    else
      'desc'
    end
  end

end
