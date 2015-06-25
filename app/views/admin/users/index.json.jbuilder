json.array!(@users) do |user|
  json.extract! user, :id, :nickname, :email, :password, :money, :role, :description, :avatar, :confirm, :token
  json.url user_url(user, format: :json)
end
