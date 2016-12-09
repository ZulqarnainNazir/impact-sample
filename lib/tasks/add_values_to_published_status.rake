desc 'Add Values to Published Status'
task add_values_to_published_status: [:environment] do
  [BeforeAfter, EventDefinition, Gallery, Offer, Post, QuickPost].each do |model|
    model.find_each do |record|
    	if record.published_status == nil
	      record.update_column :published_status, true
		end
    end
  end
end