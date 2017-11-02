class ProjectContactsController < ContactsController
  
  before_action :set_project, except: [:create, :update]
  protect_from_forgery except: :attach_contact_to_project

  def index
    if params[:project_id]
      @project_contacts = @project.contacts.paginate(page: params[:page], per_page: 8)
    else
      flash.now[:info] = 'You need to first save a project before adding contacts.'
    end
    respond_to do |format|
      format.js
    end
  end

  def new
    super
  end
  
  def create
    @project = current_org.projects.where(id: params[:contact][:project_id]).first
    @contact = current_org.contacts.new(contact_params)
    respond_to do |format| 
      if @contact.save
        flash.now[:success] = 'Contact was successfully created and added to project.'
      end
      format.js
    end
  end

  def show
    super
  end

  def update
    @project = current_org.projects.where(id: params[:contact][:project_id]).first 
    super
  end

  def destroy
    @project_contact = @project.project_contacts.where(contact_id: params[:id]).first
    respond_to do |format|
      if @project_contact.destroy
        flash.now[:success] = 'Contact was successfully removed from the project.'
      else
        flash.now[:info] = 'Contact could not be removed from the project.'
      end
      format.js
    end
  end

  def show_existing_contacts
    @project = current_org.projects.where(id: params[:id]).first
    @contacts = current_org.contacts.where.not(id: @project.project_contacts.map(&:contact_id))
    if params[:name].present? || params[:email].present?
      @contacts = @contacts.name_or_email_search(params[:name], params[:email])
    end    
    @contacts = @contacts.paginate(page: params[:page], per_page: 5)
    respond_to do |format|
      format.js
    end
  end

  def attach_contact_to_project
    @project = current_org.projects.where(id: params[:id]).first
    @project_contact = @project.project_contacts.where(contact_id: params[:contact_id]).first_or_initialize
    respond_to do |format|
      if @project_contact.save
        flash.now[:success] = 'Contact was successfully added to project.'
      end
      format.js
    end
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:project_id]).first
  end

end