class ProjectSitesController < SitesController

  before_action :set_project
  respond_to :js

  def index
    @project_sites = @project.sites.paginate(page: params[:page], per_page: 8)
    redirect_to edit_project_path(@project) if request.format.html?
  end

  def create
    @site = current_org.sites.new(site_params)
    if @site.save
      flash.now[:success] = 'Site was successfully created and added to project.'
    end
  end

  def update
    if @site.update(site_params)
      @site.create_audit_record(current_user, @project)
      flash.now[:success] = 'Site was successfully updated.'
    end
  end

  def destroy
    @project_site = @project.project_sites.where(site_id: params[:id]).first
    if @project_site.destroy
      flash.now[:success] = 'Site was successfully removed from the project.'
    else
      flash.now[:danger] = 'Site could not be removed from the project.'
    end
  end

  def show_existing_sites
    @sites = current_org.sites.where.not(id: @project.project_sites.map(&:site_id))
    filtering_params(params).each do |key, value|
      @sites = @sites.public_send(key, value) if value.present?
    end    
    @sites = @sites.paginate(page: params[:page], per_page: 5)
  end

  def attach_site_to_project
    @project_site = @project.project_sites.where(site_id: params[:id]).first_or_initialize
    if @project_site.save
      flash.now[:success] = 'Site was successfully added to project.'
    end
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:project_id]).first
  end

end
