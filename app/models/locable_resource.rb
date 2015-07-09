class LocableResource < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'resources'

  def file_url
    "http://cdn1.locable.com/uploads/resource/file/#{id}/#{file}"
  end
end
