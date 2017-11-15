class ProjectSitesController < SitesController

  before_action :set_project

  def index
    @project_sites = @project.sites.paginate(page: params[:page], per_page: 8)
    respond_to do |format|
      format.js
      format.html { redirect_to edit_project_path(@project) }
    end
  end

  def create
    @site = current_org.sites.new(site_params)
    respond_to do |format| 
      if @site.save
        flash.now[:success] = 'Site was successfully created and added to project.'
      end
      format.js
    end
  end

  def update
    respond_to do |format| 
      if @site.update(site_params)
        flash.now[:success] = 'Site was successfully updated.'
      end
      format.js
    end
  end

  def destroy
    @project_site = @project.project_sites.where(site_id: params[:id]).first
    respond_to do |format|
      if @project_site.destroy
        flash.now[:success] = 'Site was successfully removed from the project.'
      else
        flash.now[:danger] = 'Site could not be removed from the project.'
      end
      format.js
    end
  end

  def show_existing_sites
    @sites = current_org.sites.where.not(id: @project.project_sites.map(&:site_id))
    filtering_params(params).each do |key, value|
      @sites = @sites.public_send(key, value) if value.present?
    end    
    @sites = @sites.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.js
    end
  end

  def attach_site_to_project
    @project_site = @project.project_sites.where(site_id: params[:id]).first_or_initialize
    respond_to do |format|
      if @project_site.save
        flash.now[:success] = 'Site was successfully added to project.'
      end
      format.js
    end
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:project_id]).first
  end

end
