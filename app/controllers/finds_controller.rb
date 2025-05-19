class FindsController < ApplicationController

  # NOTE: Maybe this could go into the users_controller since it's searching for other people

  def search
    respond_to do |format|
      if params[:find].present?
        @uname = params[:find]
        @results = User.where('LOWER(username) LIKE ?', "%#{@uname.downcase}%")
        if @results.any?
          @user = User.find_by!(username: @uname)
          format.html { render "users/show" }
        else 
          format.html { redirect_back fallback_location: root_url, alert: "User does not exist." }
        end
      else
        format.html { redirect_back fallback_location: root_url, alert: "User does not exist." }
      end
    end

  end

end
