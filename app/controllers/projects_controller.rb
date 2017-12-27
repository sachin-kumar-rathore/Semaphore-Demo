class ProjectsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_project, only: [:edit, :update, :show]
  respond_to :html, only: [:index, :new, :edit]
  respond_to :js

  def new
    @activity = current_org.activities.where(id: params[:activity_id]).first if params[:activity_id].present?
    if @activity && !@activity.converted?
      @project = current_org.projects.new(activity_params)
    else
      @project = current_org.projects.new
    end
  end

  def index
    @projects = current_org.projects
    filtering_params(params).each do |key, value|
      @projects = @projects.public_send(key, value) if value.present?
    end
    @projects = @projects.paginate(page: params[:page], per_page: 8)     
  end

  def show
    if @project
      redirect_to edit_project_path(@project)
    else
      flash[:danger] = 'Project not found.'
      redirect_to projects_path
    end
  end

  def create
    @project = current_org.projects.new(project_params)
    if @project.save
      if params[:commit] == "Save & Close"
        flash[:success] = 'Project was successfully created.'
        redirect_to projects_path
      else
        flash[:success] = 'Project was successfully saved.'
        redirect_to edit_project_path(@project)
      end 
    else
      flash[:danger] = 'Project could not be created.'
      render :new
    end
  end
  
  def edit
    if @project.blank?
      flash[:danger] = 'Project not found.'
      redirect_to projects_path
    end
  end

  def update
    if @project.update(project_params)
      if params[:commit] == "Save & Close"
        flash[:success] = 'Project was successfully updated.'
        redirect_to projects_path
      else
        flash[:success] = 'Project was successfully updated.'
        redirect_to edit_project_path(@project)
      end 
    else
      flash[:danger] = 'Project could not be updated.'
      render :edit
    end
  end

  def check_projects_number_validity
    set_message_and_status_for_id_validity("projects")
  end

  def export
    if(params[:start_date])
      generate_data(params[:start_date], params[:end_date])
    else
      generate_data(nil, nil)
    end
  end

  def download
    start_date = Date.strptime(params[:start_date], '%m/%d/%Y')
    end_date = Date.strptime(params[:end_date], '%m/%d/%Y')
    if start_date < end_date
      if(params[:commit] == 'filter')
        redirect_to export_projects_path(start_date: start_date, end_date: end_date)
      else
        generate_data(start_date, end_date)
        respond_to do |format|
          format.xls { headers["Content-Disposition"] = "attachment; filename='successful_project_data.xls'" }
        end
      end
    else
      flash[:danger] = "Start Date should be before End Date."
      redirect_to export_projects_path
    end
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:id]).first
  end
  
  def project_params
    params.require(:project).permit(:name, :status, :project_type_id, :industry_type_id, :business_unit_id,
      :description, :active_date_str, :successful_completion_date_str, :business_type, :square_feet_requested,
      :square_footage_note, :acres_requested, :acreage_note, :new_jobs, :new_jobs_notes,
      :wages, :wages_notes, :net_new_investment, :net_new_investment_notes, :public_release_date_str,
      :public_release, :site_selector, :utilize_sites, :speculative_building, :elimination_reason_id,
      :located, :project_number, :retained_jobs, :site_visit_1_str, :site_visit_2_str, :site_visit_3_str, :company_id,
      :primary_contact_id, :source_id, :considered_location_id, :provided_service_id, :competition_id, :activity_id)
  end

  def filtering_params(params)
    params.slice(:status, :primary_contact_id, :start_date, :site_visit, :completion,
                 :project_number, :industry_type_id, :project_name, :public_release, :business_type,
                 :considered_location_id, :project_type_id, :source_id, :company_id)
  end

  def activity_params
    @activity.slice(:name, :company_id, :primary_contact_id, :description)
  end

  def generate_data(start_date, end_date)
    projects = current_org.projects.includes(:sites)
    if(start_date != nil && end_date != nil)
      projects = projects.where("projects.created_at >= ? AND projects.created_at <= ?", start_date, end_date)
    end
    @business_types = projects.group_by { |p| p.business_type }
    @total_buildings = projects.joins(:sites).group("project_sites.project_id").count.values.sum
    @new_business = @business_types['New Business'] == nil ? [0,0,0] : @business_types['New Business'].pluck(:new_jobs, :wages, :net_new_investment).transpose.map(&:sum)
    @existing_business = @business_types['Existing Business'] == nil ? [0,0,0] : @business_types['Existing Business'].pluck(:new_jobs, :wages, :net_new_investment).transpose.map(&:sum)
  end

end
