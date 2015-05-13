class Redirect < ActiveRecord::Base
  belongs_to :website

  validates :website, presence: true
  validates :from_path, format: { with: /\A\/[^\/]+/ }, uniqueness: { case_sensitive: false, scope: :website_id }
  validates :to_path, format: { with: /\A((\/|http\:\/\/|https\:\/\/))(([^\/]+.*)|(.{0}))\z/ }

  before_validation do
    self.from_path = "/#{from_path}" if !from_path.to_s.match(/\A\//)
    self.to_path = "/#{to_path}" if !to_path.to_s.match(/\A((\/|http\:\/\/|https\:\/\/))/)
  end
end
