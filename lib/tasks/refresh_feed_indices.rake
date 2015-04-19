desc 'Refresh the Feed Model Indices'
task refresh_feed_indices: [:environment] do
  [BeforeAfter, Gallery, Post, Project, Offer].each do |type|
    type.send(:__elasticsearch__).send(:refresh_index!)
  end
end
