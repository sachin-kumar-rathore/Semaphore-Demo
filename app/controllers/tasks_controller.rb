class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]


  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.get_current_org_tasks(current_org.id).paginate(page: params[:page], per_page: 10)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @users = current_org.users
    respond_to do |format|
      format.js
    end
  end

  # GET /tasks/new
  def new
    @users = current_org.users
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
    respond_to do |format|
      if @task.destroy
        format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to tasks_url, notice: 'Task could not be destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # filter_by: 1 = All_tasks, 2 = Assigned_to_me, 3 = Assigned_by_me
  def filter_tasks
    @tasks = Task.get_current_org_tasks(current_org.id)
    @tasks = params[:filter_id] == "assigned_to_me_filter" ? current_user.assigned_tasks : current_user.tasks
    @tasks =  @tasks.paginate(page: params[:page], per_page: 10)    
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.where(params[:id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :description, :start_date, :end_date, :status,
                                 :priority, :progress,:assignee_id, :project_id)
  end
end
