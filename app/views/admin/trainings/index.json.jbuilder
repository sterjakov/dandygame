json.array!(@trainings) do |training|
  json.extract! training, :id, :name, :alt_name, :description, :min_description, :people_count, :total_day, :free_day, :price_day, :decoration, :status, :meta_description, :meta_keywords
  json.url training_url(training, format: :json)
end
