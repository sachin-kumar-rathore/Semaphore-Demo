class CompanyContactsController < ContactsController

  before_action :set_company
  respond_to :js

  def index
    @company_contacts = @company.contacts.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
    redirect_to edit_company_path(@company) if request.format.html?
  end

  def create
    @contact = current_org.contacts.new(contact_params)
    if @contact.save
      flash.now[:success] = 'Contact was successfully created and added to company.'
    end
  end

  def update
    if @contact.update(contact_params)
      flash.now[:success] = 'Contact was successfully updated.'
    end
  end

  def destroy
    @company_contact = @company.company_contacts.where(contact_id: params[:id]).first
    if @company_contact.destroy
      flash.now[:success] = 'Contact was successfully removed from the company.'
    else
      flash.now[:danger] = 'Contact could not be removed from the company.'
    end
  end

  def show_existing_contacts
    @contacts = current_org.contacts.where.not(id: @company.company_contacts.map(&:contact_id))
    if params[:name].present? || params[:email].present?
      @contacts = @contacts.name_or_email_search(params[:name], params[:email])
    end    
    @contacts = @contacts.paginate(page: params[:page], per_page: 5)
  end

  def attach_contact_to_company
    @company_contact = @company.company_contacts.where(contact_id: params[:id]).first_or_initialize
    if @company_contact.save
      flash.now[:success] = 'Contact was successfully added to company.'
    end
  end

  private

  def set_company
    @company = current_org.companies.where(id: params[:company_id]).first
  end

end
