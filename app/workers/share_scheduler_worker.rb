class ShareSchedulerWorker
  include Sidekiq::Worker

  def perform(*args)
    sharer = MakeFacebookShare.new(bussiness_id: args[0], post_id: args[1], share_id: args[2])
    sharer.share_post
  end
end
