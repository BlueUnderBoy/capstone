# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :citext           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :citext
#  goals_count            :integer          default(0)
#  last_name              :citext
#  profile_pic            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :own_goals, foreign_key: "owner_id", class_name: "Goal"
  has_many :sent_friend_requests, foreign_key: :sender_id, class_name: "FriendRequest"
  has_many :received_friend_requests, foreign_key: :recipient_id, class_name: "FriendRequest"
end
