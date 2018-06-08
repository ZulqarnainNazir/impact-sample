class Widgets::ContactFormWidgetsController < Widgets::BaseController
  include Recaptcha::Verify

  def index
    # FIXME: This is a show action
    @contact_form = ContactForm.find_by(:uuid => params[:uuid])
    @business = @contact_form.business
    if @contact_form.blank?
      return false
    end

    if !params[:widget_layout].blank?
      @widget.layout = params[:widget_layout]
    end
  end

  def submit
    # FIXME: This should be a create action
    @contact_form = ContactForm.find_by(:uuid => params[:uuid])
    @business = @contact_form.business
    required_fields_error = ""
    # FIXME: This should be generated via params through the form, not built after-the-fact using a private method
    contact_hash = build_contact_hash @contact_form, @business
    # if the issue is the honey pot we don't want to let the user/bot know that it failed.
    if !params[:honey].blank?
      redirect_to "/widgets/contact_form_widgets/#{@contact_form.uuid}", :flash => { :notice => "Contact Information Successfully Processed" }
      return
    end
    if verify_recaptcha(model: @contact_form )
      begin
        FormSubmission.transaction do
          contact = @business.contacts.find_and_update_or_create contact_hash

          submission = FormSubmission.new(:business_id => @business.id, :contact_form_id => @contact_form.id, :contact_id => contact.id)
          submission.save!

          @contact_form.contact_form_form_fields.each do |field|
            required_fields_error << "#{field.label} is required\n" if field.required && params[field.form_field.name.to_sym].blank?
            FormSubmissionValue.create(:form_submission_id => submission.id, :contact_form_form_field_id => field.id, :value => params[field.form_field.name.to_sym])
          end
          raise StandardError, required_fields_error if !required_fields_error.blank?
        end
      rescue StandardError => error
        redirect_to "/widgets/contact_form_widgets/#{@contact_form.uuid}?#{params.to_query}", :flash => { :error => "Please Fill all Required Fields\n\n" << error.message }
      else
        redirect_to "/widgets/contact_form_widgets/#{@contact_form.uuid}", :flash => { :notice => "Contact Information Successfully Sent" }
      end
    else
      redirect_to :back, flash: { error: "You do not appear to be human, or you forgot to answer the recaptcha prompt" }
    end
  end

  private

  def build_contact_hash contact_form, business
    contact_hash = {}
    contact_hash[:business_id] = business.id
    contact_form.contact_form_form_fields.each do |field|
      if !field.form_field.contact_field.blank?
        contact_hash[field.form_field.contact_field.to_sym] = params[field.form_field.name.to_sym]
      end
    end
    contact_hash
  end
end
