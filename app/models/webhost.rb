class Webhost < ActiveRecord::Base
  belongs_to :website, touch: true

  validates :name, presence: true, uniqueness: { case_sensitive: true }, format: { with: /\A[\w\.]+\z/ }

  validate do
    errors.add :name, :invalid if name && name.to_s.match(/\Ahttps?:/)
  end

  before_update -> { !name_changed? }

  if ENV['HEROKU_APP_NAME'] && ENV['HEROKU_API_KEY']
    after_commit on: :create do
      PlatformAPI.connect(ENV['HEROKU_API_KEY']).domain.create(ENV['HEROKU_APP_NAME'], hostname: name)
    end

    after_commit on: :destroy do
      PlatformAPI.connect(ENV['HEROKU_API_KEY']).domain.delete(ENV['HEROKU_APP_NAME'], name)
    end
  end

  def self.primary
    where(primary: true)
  end
end
