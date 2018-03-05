# Manage projects belonging to an organization
class ProjectsController < ApplicationController
  include ProjectModule
  before_action :authenticate_user!
  before_action :set_project, only: %i[edit update show]
  before_action :convert_site_visit_dates, only: [:update, :create]
  respond_to :html, only: %i[index new edit]
  respond_to :js

  def new
    if params[:activity_id].present?
      @activity = current_org.activities
                             .where(id: params[:activity_id]).first
    end
    @project = assign_project
    3.times { @project.site_visits.build }
  end

  def index
    @projects =  request.format.html? ? current_org.projects.active : current_org.projects
    @projects = @projects.includes(:site_visits).references(:site_visits)
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
      flash[:success] = 'Project was successfully created.'
      redirect_after_commit
    else
      flash[:danger] = 'Project could not be created.'
      render :new
    end
  end

  def edit
    (3 - @project.site_visits.count).times { @project.site_visits.build }
    return unless @project.blank?
    flash[:danger] = 'Project not found.'
    redirect_to projects_path
  end

  def update
    if @project.update(project_params)
      flash[:success] = 'Project was successfully updated.'
      redirect_after_commit
    else
      flash[:danger] = 'Project could not be updated.'
      render :edit
    end
  end

  def check_projects_number_validity
    assign_message_and_status_for_id_validity('projects')
  end

  def export_form; end

  def export
    @projects = current_org.projects
    filtering_params(params).each do |key, value|
      @projects = @projects.public_send(key, value) if value.present?
    end
    if @projects.present?
      respond_to do |format|
        format.xls {
          file_name =  (params[:custom_export] == 'true') ? 'customProjectExport' : 'basicProjectExport'
          response.headers['Content-Disposition'] = "attachment; filename=\"#{file_name}.xls\""
        }
      end
    else
      redirect_to export_form_projects_path
      flash[:danger] = 'No records are found'
    end
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:id]).first
  end

  def project_params
    params.require(:project).permit(:name, :status, :project_type_id,
                                    :industry_type_id, :business_unit_id,
                                    :description, :active_date_str,
                                    :successful_completion_date_str,
                                    :business_type, :square_feet_requested,
                                    :square_footage_note, :acres_requested,
                                    :acreage_note, :new_jobs, :new_jobs_notes,
                                    :wages, :wages_notes, :net_new_investment,
                                    :net_new_investment_notes,
                                    :public_release_date_str, :public_release,
                                    :site_selector, :utilize_sites,
                                    :speculative_building,
                                    :elimination_reason_id,
                                    :located, :project_number, :retained_jobs,
                                    :company_id,
                                    :primary_contact_id, :source_id,
                                    :considered_location_id,
                                    :incentive_id, :other_square_ft_requested,
                                    :competition_id, :activity_id, :project_manager_id,
                                    site_visits_attributes: [:id, :visit_date, :_destroy])
  end

  def filtering_params(params)
    params.slice(:status, :primary_contact_id, :start_date, :site_visit,
                 :completion, :project_number, :industry_type_id,
                 :project_name, :public_release, :business_type,
                 :considered_location_id, :project_type_id, :source_id,
                 :company, :project_manager_id)
  end

  def activity_params
    @activity.slice(:name, :company_id, :primary_contact_id, :description)
  end

  def assign_project
    if @activity && !@activity.converted?
      current_org.projects.new(activity_params)
    else
      current_org.projects.new
    end
  end

  def redirect_after_commit
    if params[:commit] == 'Save & Close'
      redirect_to projects_path
    else
      redirect_to edit_project_path(@project)
    end
  end

end
