class CreateGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :goals do |t|
      t.string :image
      t.string :name
      t.string :amount_needed
      t.string :amount_saved
      t.string :status, default: "saving"
      t.references :owner, null: false, foreign_key: { to_table: :users}

      t.timestamps
    end
  end
end
