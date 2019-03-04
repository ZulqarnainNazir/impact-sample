class Ahoy::Event < ActiveRecord::Base
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user

  after_save :set_widget_status

  private
    def set_widget_status
      if self.properties['type'] == 'Content Widget'
        w = ContentFeedWidget.find(self.properties['type_id'])
        w.status = true
        w.save
      elsif self.properties['type'] == 'Calendar Widget'
        w = CalendarWidget.find(self.properties['type_id'])
        w.status = true
        w.save
      elsif self.properties['type'] == 'Directory Widget'
        w = DirectoryWidget.find(self.properties['type_id'])
        w.status = true
        w.save
      end
    end
end
