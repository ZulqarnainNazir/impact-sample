desc "Add Communities"
task :add_communities => :environment do

  c = Community.find(5)

  Business.all.each do | b |
    b.community_id = 5
    b.save



    Ambassador.create(
      community: c,
      business: b,
      anchor: false,
      champion: false
    )
  end



end
