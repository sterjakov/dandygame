json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :id, :user_id, :training_id, :description, :bad, :good, :status
  json.url feedback_url(feedback, format: :json)
end
