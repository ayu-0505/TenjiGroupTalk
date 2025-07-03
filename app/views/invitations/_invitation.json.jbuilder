json.extract! invitation, :id, :token, :expires_at, :user_id, :group_id, :created_at, :updated_at
json.url invitation_url(invitation, format: :json)
