if Rails.env.development? || Rails.env.test?
  ActiveRecordQueryTrace.enabled = true
end
