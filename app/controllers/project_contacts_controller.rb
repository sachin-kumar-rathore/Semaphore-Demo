class ProjectContactsController < ContactsController
  
  before_action :set_project
  respond_to :js

  def index
    @project_contacts = @project.contacts.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
    redirect_to edit_project_path(@project) if request.format.html?
  end
  
  def create
    @contact = current_org.contacts.new(contact_params)
    if @contact.save
      flash.now[:success] = 'Contact was successfully created and added to project.'
    end
  end

  def update
    if @contact.update(contact_params)
      flash.now[:success] = 'Contact was successfully updated.'
    end
  end

  def destroy
    @project_contact = @project.project_contacts.where(contact_id: params[:id]).first
    if @project_contact.destroy
      flash.now[:success] = 'Contact was successfully removed from the project.'
    else
      flash.now[:danger] = 'Contact could not be removed from the project.'
    end
  end

  def show_existing_contacts
    @contacts = current_org.contacts.where.not(id: @project.project_contacts.map(&:contact_id))
    if params[:name].present? || params[:email].present?
      @contacts = @contacts.name_or_email_search(params[:name], params[:email])
    end    
    @contacts = @contacts.paginate(page: params[:page], per_page: 5)
  end

  def attach_contact_to_project
    @project_contact = @project.project_contacts.where(contact_id: params[:id]).first_or_initialize
    if @project_contact.save
      flash.now[:success] = 'Contact was successfully added to project.'
    end
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:project_id]).first
  end


end