# Manage projects inside a company
class CompanyProjectsController < ManageGeneralModulesController
  before_action :authenticate_user!, :authorized_module?
  before_action :set_company
  respond_to :js

  def show_existing_projects
    @projects = current_org.projects.where(company_id: nil)
    filtering_params(params).each do |key, value|
      @projects = @projects.public_send(key, value) if value.present?
    end
    @projects = @projects.paginate(page: params[:page], per_page: 5)
                         .order('updated_at DESC')
  end

  def attach_project_to_company
    @project = current_org.projects.where(id: params[:id]).first
    return unless @project.update_attribute(:company_id, @company.id)
    flash.now[:success] = 'Project was successfully associated to company.'
    load_company_projects
  end

  private

  def set_company
    @company = current_org.companies.where(id: params[:company_id]).first
  end

  def filtering_params(params)
    params.slice(:status, :primary_contact_id, :start_date, :site_visit,
                 :completion, :project_number, :industry_type_id,
                 :project_name, :public_release, :business_type,
                 :project_type, :considered_location_id, :company)
  end

  def load_company_projects
    @company_projects = @company.projects
                                .paginate(page: params[:page], per_page: 8)
                                .order('updated_at DESC')
  end
end
