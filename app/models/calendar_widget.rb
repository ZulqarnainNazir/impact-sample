class CalendarWidget < ActiveRecord::Base
  include Concerns::BusinessIds
  after_initialize :init
  belongs_to :business

  validates :name, presence: true

  def init
    self.uuid ||= SecureRandom.uuid
  end

  def cache_sensitive_key(params)
    [params[:page], Time.at((Time.now.to_f / 5.minutes).floor * 5.minutes).to_i].reject(&:blank?).join('-').parameterize
  end

  def self.filter_kinds
    [[0, "Events"],
     [1, "Classes"],
     [2, "Deadlines"]]
  end

  def content_types
    return ['Event']
  end
end
