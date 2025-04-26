class FindsController < ApplicationController

  def search
    if params[:find].present?
      @uname = params[:find]
      @results = User.where('LOWER(username) LIKE ?', "%#{@uname.downcase}%")
      if @results.any?
        @user = User.find_by!(username: @uname)
        render "users/show"
      else 
        format.html { redirect_back fallback_location: root_url, notice: "User does not exist." }
      end
    else
      format.html { redirect_back fallback_location: root_url, notice: "User does not exist." }
    end

  end

end
