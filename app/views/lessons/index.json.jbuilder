json.array!(@lessons) do |lesson|
  json.extract! lesson, :name, :url, :description, :user_id
  json.url lesson_url(lesson, format: :json)
end