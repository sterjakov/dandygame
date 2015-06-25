json.array!(@comments) do |comment|
  json.extract! comment, :id, :user_id, :description, :bad, :good, :status
  json.url comment_url(comment, format: :json)
end
