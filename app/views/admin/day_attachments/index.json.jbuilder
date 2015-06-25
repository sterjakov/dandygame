json.array!(@day_attachments) do |day_attachment|
  json.extract! day_attachment, :id, :day_id, :attachment
  json.url day_attachment_url(day_attachment, format: :json)
end
