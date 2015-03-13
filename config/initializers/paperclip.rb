Paperclip.interpolates(:attachment_timestamp) do |attachment, _|
  attachment.instance_read(:updated_at).to_i
end
