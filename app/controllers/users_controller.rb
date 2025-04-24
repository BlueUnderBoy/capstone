class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params.fetch(:username))
  end

  def feed
    @goals = Goal.all

    @user = User.find(current_user.id)
    
    @user.own_goals = Goal.where(owner_id: @user).order(created_at: :desc)
  end

end
