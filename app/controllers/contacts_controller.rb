# Manage contacts inside an organization
class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: %i[show edit update destroy]
  respond_to :html, only: %i[index]
  respond_to :js

  def index
    @contacts = current_org.contacts
    @contacts = @contacts.where('id = ?', params[:id]) if params[:id].present?

    if params[:name].present? || params[:email].present?
      @contacts = search_contacts
    end
    @contacts = @contacts.paginate(page: params[:page], per_page: Contact::PAGINATION_VALUE)
                         .order('updated_at DESC')
  end

  def show; end

  def new
    @contact = current_org.contacts.new
  end

  def edit; end

  def create
    @contact = current_org.contacts.new(contact_params)
    return unless @contact.save
    flash.now[:success] = 'Contact was successfully created.'
    load_contacts
  end

  def update
    return unless @contact.update(contact_params)
    flash.now[:success] = 'Contact was successfully updated.'
    load_contacts
  end

  def destroy
    if @contact.destroy
      flash.now[:success] = 'Contact was successfully deleted.'
    else
      flash.now[:danger] = 'Contact could not be deleted.'
    end
    load_contacts
  end

  def import_contacts
    errors = Contact.import(params[:import], current_org.id)
    if errors.blank?
      flash[:success] = 'Contacts Successfully Imported.'
    else
      flash[:danger] = 'Contacts could not be imported from file.
                        <br/>' + errors.join('<br/>')
    end
    redirect_back fallback_location: contacts_path
  end

  def export
    @contacts = current_org.contacts
    if @contacts.present?
      respond_to do |format|
        format.xls {
          response.headers['Content-Disposition'] = "attachment; filename=\"contactExport.xls\""
        }
      end
    else
      redirect_to exports_path
      flash[:danger] = 'No records are found'    
    end
  end

  private

  def set_contact
    @contact = current_org.contacts.where(id: params[:id]).first
  end

  def load_contacts
    @contacts = current_org.contacts
                           .paginate(page: params[:page], per_page: Contact::PAGINATION_VALUE)
                           .order('updated_at DESC')
  end

  def search_contacts
    @contacts.name_or_email_search(params[:name], params[:email])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number_1,
                                    :phone_number_2, :address_line_1,
                                    :address_line_2, :city_state_zip,
                                    :fax, :business_unit_id, :website,
                                    :contact_category_id, :title,
                                    :cell_phone, :notes, :project_id,
                                    :company_id, :organization_name, :linkedin_url)
  end
end
