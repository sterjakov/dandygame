json.array!(@training_attachments) do |training_attachment|
  json.extract! training_attachment, :id, :training_id, :attachment
  json.url training_attachment_url(training_attachment, format: :json)
end
