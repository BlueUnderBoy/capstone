class FriendRequestsController < ApplicationController
  before_action :set_friend_request, only: %i[ update destroy ]

  # POST /follow_requests or /follow_requests.json
  def create
    @friend_request = FriendRequest.new(friend_request_params)
    @friend_request.sender = current_user

    respond_to do |format|
      if @friend_request.save
        format.html { redirect_back fallback_location: root_url, notice: "Friend request was successfully created." }
        format.json { render :show, status: :created, location: @friend_request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @friend_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /follow_requests/1 or /follow_requests/1.json
  def update
    respond_to do |format|
      if @friend_request.update(friend_request_params)
        format.html { redirect_back fallback_location: root_url, notice: "Friend request was successfully updated." }
        format.json { render :show, status: :ok, location: @friend_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @friend_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follow_requests/1 or /follow_requests/1.json
  def destroy
    @friend_request.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_url, notice: "Friend request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend_request
      @friend_request = FriendRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friend_request_params
      params.require(:friend_request).permit(:recipient_id, :sender_id, :status)
    end
end
