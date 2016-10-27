class ToDoComment < ActiveRecord::Base
  belongs_to :commenter, class_name: 'User'
  belongs_to :to_do

  after_create :notify_of_comment

  private

  def notify_of_comment
    to_do.notify_all_of_status_change("'#{to_do.title}' has received new comment", :updates_or_comments, commenter_id)
  end
end
