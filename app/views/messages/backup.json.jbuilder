json.array!(@messages) do |message|
  json.extract! message, :content, :created_at
  json.url message_url(message, format: :json)
end
