class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]


  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.where(:assigned_to => current_user.id).paginate(:page => params[:page], :per_page => 10)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @users = current_user.organization.users
    respond_to do |format|
      format.js
    end
  end

  # GET /tasks/new
  def new
    @users = current_user.organization.users
    @task = current_user.tasks.new
    respond_to do |format|
      format.js
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # filter_by: 1 = Assigned_to_me, 2 = Assigned_by_me, 3 = All_tasks
  def filter_tasks
    if params[:filter_by] == "1"
      @tasks = Task.where(:assigned_to => current_user.id).paginate(:page => params[:page], :per_page => 10)
    elsif params[:filter_by] == "2"
      @tasks = current_user.tasks.paginate(:page => params[:page], :per_page => 10)
    else
      organization = current_user.organization
      @tasks =  Task.joins(:user => :organization).where(:users => {organization_id: organization.id}).paginate(:page => params[:page], :per_page => 10)
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :description, :start_date, :end_date, :status,
                                 :priority, :progress, :assigned_to, :project_id)
  end
end
