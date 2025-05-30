# == Schema Information
#
# Table name: goals
#
#  id            :bigint           not null, primary key
#  amount_needed :string
#  amount_saved  :string
#  image         :string
#  name          :string
#  status        :string           default("saving")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :bigint           not null
#
# Indexes
#
#  index_goals_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class Goal < ApplicationRecord
  mount_uploader :image, ImageUploader 
  
  belongs_to :owner, class_name: "User"

  validates :name, presence: true
  validates :image, presence: true 
  validates :amount_needed, presence: true

  has_many :completed, dependent: :destroy
  has_many :pending, dependent: :destroy

  scope :past_week, -> { where(created_at: 1.week.ago...) }
  scope :latest, -> { order(created_at: :desc) }

  enum :status, { saving: "saving", completed: "completed" }
end
