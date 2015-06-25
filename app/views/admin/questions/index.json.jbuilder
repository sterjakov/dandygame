json.array!(@questions) do |question|
  json.extract! question, :id, :user_id, :day_id, :status, :description, :reviewed
  json.url question_url(question, format: :json)
end
