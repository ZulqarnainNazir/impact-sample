desc 'Create the Feed Model Indices'
task create_feed_indices: [:environment] do
  [BeforeAfter, Gallery, Post, Offer].each do |type|
    type.send(:__elasticsearch__).send(:create_index!, force: true)
    type.send(:__elasticsearch__).send(:refresh_index!)
  end
end
