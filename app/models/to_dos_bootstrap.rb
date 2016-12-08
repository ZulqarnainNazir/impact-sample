class ToDosBootstrap
  module Config
    def self.read_with(context)
      config = File.read(Rails.root.join('config', 'default_to_dos.yml'))
      config_with_context = ERB.new(config).result(context)

      YAML.load(config_with_context)
    end
  end

  attr_reader :business

  def initialize(business)
    @business = business
  end

  def run
    config[:default_to_dos].map { |todo| create_to_do(todo) }

    subscribe_admins_to_updates
  end

  private

  def config
    @config ||= Config.read_with(binding)
  end

  def create_to_do(to_do_config)
    business.to_dos.create(title: to_do_config[:title],
                           description: to_do_config[:description],
                           group: to_do_config[:group])
  end

  def subscribe_admins_to_updates
    User.where(super_user: true).each do |user|
      user.following_businesses << business
    end
  end
end
