class ToDo < ActiveRecord::Base
  belongs_to :business
  has_many :to_do_notification_settings, through: :business

  has_many :comments, class_name: 'ToDoComment'

  enum status: [:active, :removed]
  enum submission_status: [:pending, :submitted, :accepted]

  enum group: [:custom, :getting_started, :preparing_to_launch, :after_launch]

  validates :title, :description, presence: true

  scope :alphabetical, -> { order('LOWER(title) ASC') }
  scope :by_due_date, -> { order('due_date ASC') }
  scope :overdue, -> { where('due_date < ?', Time.now) }
  scope :due_now, -> { where('due_date > ? AND due_date < ?', Time.now, Time.now + 2.days) }

  before_update :notify_all

  def notify_all
    if status_changed?
      notify_active if active?
      notify_removed if removed?
    elsif submission_status_changed?
      notify_submitted if submitted?
      notify_accepted if accepted?
    end
  end

  def notify_active
    notify_all_of_status_change("'#{title}' has been activated", :updates_or_comments)
  end

  def notify_removed
    notify_all_of_status_change("'#{title}' has been removed", :updates_or_comments)
  end

  def notify_submitted
    notify_all_of_status_change("'#{title}' has been submitted for review", :updates_or_comments)
  end

  def notify_accepted
    notify_all_of_status_change("'#{title}' has been accepted", :accepted)
  end

  def notify_all_of_status_change(message, notifiable, except_user_id = nil)
    business_users = if except_user_id
      business_with_setting.users.where.not(id: except_user_id)
    else
      business_with_setting.users
    end

    notify_authorized_business_users(business_users, message, notifiable)

    skip_user_ids = if except_user_id
      business_users.map(&:id) << except_user_id
    else
      business_users.map(&:id)
    end

    unauthorized_settings = to_do_notification_settings.where.not(user_id: skip_user_ids)
    unauthorized_settings.each do |setting|
      setting.notify(message, notifiable, self)
    end
  end

  def notify_authorized_business_users(users, message, notifiable)
    users.each do |user|
      setting = to_do_setting_for_user(user)

      setting.notify(message, notifiable, self)
    end
  end

  def business_with_setting
    @business_with_setting ||= Business.includes(users: :to_do_notification_settings).find(business_id)
  end

  def to_do_setting_for_user(user)
    setting = to_do_notification_settings.find_by(user: user)

    return setting if setting

    ToDoNotificationSetting.new(user: user, business: business_with_setting)
  end
end
