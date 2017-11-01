class ProjectsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_project, only: [:edit, :update, :dashboard]

  def dashboard
    if @project.blank? && params[:id].present?
      redirect_to projects_path, notice: 'Project not found.'
    end  
  end
  
  def new
    @project = current_org.projects.new
    respond_to do |format|
      format.js
    end
  end

  def index
    @projects = current_org.projects
    filtering_params(params).each do |key, value|
      @projects = @projects.public_send(key, value) if value.present?
    end
    @projects = @projects.paginate(page: params[:page], per_page: 8)      
  end

  def create
    @project = current_org.projects.new(project_params)
    if @project.save
      if params[:commit] == "Save & Close"
        redirect_to projects_path, notice: 'Project was successfully created.'
      else
        redirect_to dashboard_projects_path(id: @project.id), notice: 'Project was successfully saved.'
      end 
    else
      flash[:notice] = 'Project could not be created.'
      redirect_to dashboard_projects_path
    end
  end
  
  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @project.update(project_params)
      if params[:commit] == "Save & Close"
        redirect_to projects_path, notice: 'Project was successfully updated.'
      else
        redirect_to dashboard_projects_path(id: @project.id), notice: 'Project successfully updated.'
      end 
    else
      flash[:notice] = 'Project could not be updated.'
      redirect_to dashboard_projects_path(id: project.id)
    end
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:id]).first
  end
  
  def project_params
    params.require(:project).permit(:name, :status, :project_type, :industry_type, :business_unit,
      :description, :active_date_str, :successful_completion_date_str, :business_type, :square_feet_requested,
      :square_footage_note, :acres_requested, :acreage_note, :new_jobs, :new_jobs_notes,
      :wages, :wages_notes, :net_new_investment, :net_new_investment_notes, :public_release_date_str,
      :public_release, :site_selector, :utilize_sites, :speculative_building, :elimination_reason,
      :located, :unique_id, :retained_jobs, :site_visit_1_str, :site_visit_2_str, :site_visit_3_str, :company_id,
      :primary_contact_id, :source)
  end

  def filtering_params(params)
    params.slice(:status, :primary_contact_id, :start_date, :site_visit, :completion, :unique_id, :industry_type, :project_name, :public_release, :business_type)
  end
  
end
