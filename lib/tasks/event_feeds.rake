# Tasks for scheduling imports of event feeds
#
# 1. `import_feeds_for_subscribed_businesses` is for importing feeds associated
# to businesses with subscription plans.
#
#   Usage:
#
#     rake event_feeds:import_feeds_for_subscribed_businesses
#
# 2. `import_feeds_for_businesses_with_free_plan` is for importing feeds associated
# to businesses on the free plan.
#
#   Usage:
#
#     rake event_feeds:import_feeds_for_businesses_with_free_plan
#
namespace :event_feeds do
  task import_feeds_for_subscribed_businesses: :environment do
    business_ids = Business.joins(subscription: :subscription_plan)
                           .where(subscription_plans: { name: ["Build", "Legacy"] })
                           .pluck(:id)

    EventFeed.where(business_id: business_ids).each do |feed|
      puts "Importing feed #{feed.id}"
      feed.import(false)
    end
  end

  task import_feeds_for_businesses_with_free_plan: :environment do
    business_ids =  Business.joins(subscription: :subscription_plan)
                            .where(subscription_plans: { name: ["Engage"] })
                            .pluck(:id)

    EventFeed.where(business_id: business_ids).each do |feed|
      puts "Importing feed #{feed.id}"
      feed.import(false)
    end
  end
end
