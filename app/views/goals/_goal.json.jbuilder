json.extract! goal, :id, :image, :name, :amount_needed, :amount_saved, :status, :owner_id, :created_at, :updated_at
json.url goal_url(goal, format: :json)
