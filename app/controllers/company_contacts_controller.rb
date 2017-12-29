# Manage contacts inside a particular company
class CompanyContactsController < ContactsController
  before_action :set_company
  respond_to :js

  def create
    @contact = current_org.contacts.new(contact_params)
    return unless @contact.save
    flash.now[:success] = 'Contact was successfully created
      and added to company.'
    load_company_contacts
  end

  def update
    return unless @contact.update(contact_params)
    flash.now[:success] = 'Contact was successfully updated.'
    load_company_contacts
  end

  def destroy
    @company_contact = @company.company_contacts
                               .where(contact_id: params[:id]).first
    if @company_contact.destroy
      flash.now[:success] = 'Contact was successfully removed from the company.'
      load_company_contacts
    else
      flash.now[:danger] = 'Contact could not be removed from the company.'
    end
  end

  def show_existing_contacts
    @contacts = current_org.contacts
                           .where
                           .not(id: @company.company_contacts.map(&:contact_id))
    filter_contacts
    @contacts = @contacts.paginate(page: params[:page], per_page: 5)
  end

  def attach_contact_to_company
    @company_contact = @company.company_contacts
                               .where(contact_id: params[:id])
                               .first_or_initialize
    return unless @company_contact.save
    flash.now[:success] = 'Contact was successfully added to company.'
    load_company_contacts
  end

  private

  def set_company
    @company = current_org.companies.where(id: params[:company_id]).first
  end

  def load_company_contacts
    @company_contacts = @company.contacts
                                .paginate(page: params[:page], per_page: 8)
                                .order('updated_at DESC')
  end

  def filter_contacts
    return unless params[:name].present? || params[:email].present?
    @contacts = @contacts.name_or_email_search(params[:name], params[:email])
  end
end
