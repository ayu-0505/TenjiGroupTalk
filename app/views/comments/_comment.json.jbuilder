json.extract! comment, :id, :description, :user_id, :talk_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
