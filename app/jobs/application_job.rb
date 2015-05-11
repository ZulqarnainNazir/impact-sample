class ApplicationJob < ActiveJob::Base
  queue_as :default

  rescue_from ActiveJob::DeserializationError, with: -> {}
end
