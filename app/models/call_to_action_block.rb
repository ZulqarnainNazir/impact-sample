class CallToActionBlock < Block
  before_validation do
    self.theme = 'default'
  end
end
