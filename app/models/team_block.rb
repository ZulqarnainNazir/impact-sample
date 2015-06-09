class TeamBlock < Block
  before_validation do
    self.theme = 'vertical' unless theme?
  end

  def cache_sensitive?
    true
  end

  def cache_sensitive_key(params)
    if business
      business.team_members.order(updated_at: :desc).first.pluck(:updated_at)[0]
    end
  end
end
