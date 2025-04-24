class AddGoalsCountToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :goals_count, :integer, default: 0
  end
end
