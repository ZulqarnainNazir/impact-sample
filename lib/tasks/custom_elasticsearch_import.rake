desc 'Custom Elasticsearch Import'
task custom_elasticsearch_import: [:environment] do

	Gallery.import force: true
	QuickPost.import force: true
	EventDefinition.import force: true
	BeforeAfter.import force: true
	Offer.import force: true
	Event.import force: true
	Location.import force: true
	PostSection.import force: true

	#force: true is not added here. forcing the import results in posts mappings'
	#nested content (post_section) to lose its type: nested status.
	Post.import

end