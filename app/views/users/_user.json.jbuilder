json.extract! user, :id, :email, :name, :phone, :created_at, :updated_at
json.url user_url(user, format: :json)
