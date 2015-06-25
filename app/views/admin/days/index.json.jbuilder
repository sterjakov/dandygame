json.array!(@days) do |day|
  json.extract! day, :id, :training_id, :number, :name, :description
  json.url day_url(day, format: :json)
end
