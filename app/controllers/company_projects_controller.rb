class CompanyProjectsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_company
  respond_to :js

  def index
    @company_projects = @company.projects.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
    redirect_to edit_company_path(@company) if request.format.html?
  end

  def show_existing_projects
    @projects = current_org.projects.where(company_id: nil).paginate(page: params[:page], per_page: 5).order('updated_at DESC')
  end

  def attach_project_to_company
    @project = current_org.projects.where(id: params[:id]).first
    if @project.update_attribute(:company_id, @company.id)
      flash.now[:success] = 'Project was successfully associated to company.'
    end
  end

  private

  def set_company
    @company = current_org.companies.where(id: params[:company_id]).first
  end

end
