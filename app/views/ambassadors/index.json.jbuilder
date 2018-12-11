json.array!(@ambassadors) do |ambassador|
  json.extract! ambassador, :id
  json.url ambassador_url(ambassador, format: :json)
end
