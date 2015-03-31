module ContentHelper
  def title(string_or_locals = {})
    if string_or_locals.is_a? String
      content_for :title, string_or_locals
    end
  end

  def description(string_or_locals = {})
    if string_or_locals.is_a? String
      content_for :description, string_or_locals
    end
  end

  def errors_for(resource, message: nil)
    if resource && resource.errors.full_messages.any?
      render partial: 'errors', locals: { message: message, error_messages: resource.errors.full_messages }
    end
  end
end
