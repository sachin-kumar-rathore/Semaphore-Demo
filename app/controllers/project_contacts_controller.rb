class ProjectContactsController < ContactsController
  
  before_action :set_project, except: [:create, :update]

  def index
    @project_contacts = @project.contacts.paginate(page: params[:page], per_page: 8)
    respond_to do |format|
      format.js
      format.html { redirect_to edit_project_path(@project) }
    end
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

  def update
    @project = current_org.projects.where(id: params[:contact][:project_id]).first
    respond_to do |format| 
      if @contact.update(contact_params)
        flash.now[:success] = 'Contact was successfully updated.'
      end
      format.js
    end
  end

  def destroy
    @project_contact = @project.project_contacts.where(contact_id: params[:id]).first
    respond_to do |format|
      if @project_contact.destroy
        flash.now[:success] = 'Contact was successfully removed from the project.'
      else
        flash.now[:danger] = 'Contact could not be removed from the project.'
      end
      format.js
    end
  end

  def show_existing_contacts
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
    @project_contact = @project.project_contacts.where(contact_id: params[:id]).first_or_initialize
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