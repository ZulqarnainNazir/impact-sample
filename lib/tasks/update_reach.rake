desc 'Daily task that will update Reach for each busienss'
task :update_reach => :environment do

    # Calculates the number of times any content from an account is shown and updates Reach in the business table.
    # Index Impressions + Content View Impressions

    aggregate_occurences = []
    Ahoy::Event.where('time > ?', Time.now - 30.days).where(name: "Reach").each do |event|
      if event.properties['occurences'] && event.properties['occurences'].present?
        aggregate_occurences << JSON.parse(event.properties['occurences'])
      end
    end

    # TODO - Add in Contnet View counts as well

    reach_counts = aggregate_occurences.flatten.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }

    reach_counts.each do |k, v|
      b = Business.find(k)
      # puts b.name
      b.reach = v
      b.save
    end

    puts "Reach Counts by Business:"
    puts reach_counts

end
