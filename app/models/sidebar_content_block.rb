class SidebarContentBlock < Block
  before_validation do
    self.theme = 'default'
  end
end
