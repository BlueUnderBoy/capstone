json.extract! friend_request, :id, :recipient_id, :sender_id, :status, :created_at, :updated_at
json.url friend_request_url(friend_request, format: :json)
