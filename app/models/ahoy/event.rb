class Ahoy::Event < ActiveRecord::Base
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user

  after_save :set_widget_status

  private
    def set_widget_status
      if self.properties['type'] == 'Content Widget' || self.properties['type'] == 'Website Content Feed'
        w = ContentFeedWidget.find(self.properties['type_id'])
        if w.company_list_ids.count > 1
          w.status = true
          w.save
        end
      elsif self.properties['type'] == 'Calendar Widget' || self.properties['type'] == 'Website Calendar Feed'
        w = CalendarWidget.find(self.properties['type_id'])
        if w.company_list_ids.count > 1
          w.status = true
          w.save
        end
      elsif self.properties['type'] == 'Directory Widget' || self.properties['type'] == 'Website Directory Embed'
        w = DirectoryWidget.find(self.properties['type_id'])
        w.status = true
        w.save
      end
    end
end
