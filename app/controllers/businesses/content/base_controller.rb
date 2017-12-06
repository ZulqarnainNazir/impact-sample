class Businesses::Content::BaseController < Businesses::BaseController
  before_action -> { confirm_module_activated(1) }
  include ActionView::Helpers::TextHelper
end
