class GoalsController < ApplicationController
  before_action :set_goal, only: %i[ show edit update destroy ]

  # GET /photos or /photos.json
  def index
    @goals = Goal.all

    @user = User.find(current_user.id)
    
    @user.own_goals = Goal.where(owner_id: @user).order(created_at: :desc)
  
  end

  # GET /photos/1 or /photos/1.json
  def show
    
  end

  # GET /photos/new
  def new
    @goal = Goal.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos or /photos.json
  def create
    @goal = Goal.new(goal_params)
 
    respond_to do |format|
      if @goal.save
        format.html { redirect_to @goal, notice: "Goal was successfully created." }
        format.json { render :show, status: :created, location: @goal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1 or /photos/1.json
  def update
    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to @goal, notice: "Goal was successfully updated." }
        format.json { render :show, status: :ok, location: @goal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1 or /photos/1.json
  def destroy
    @goal.destroy!

    respond_to do |format|
      format.html { redirect_to goals_path, status: :see_other, notice: "Goal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def goal_params
      params.expect(goal: [ :image, :name, :amount_needed, :amount_saved, :owner_id, :status ])
    end
end
