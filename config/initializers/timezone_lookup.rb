begin
  Timezone::Lookup.config(:google) do |c|
    c.api_key = ENV['GOOGLE_TIMEZONE_API_KEY']
  end
rescue
  puts 'GOOGLE_TIMEZONE_API_KEY not present'
end
