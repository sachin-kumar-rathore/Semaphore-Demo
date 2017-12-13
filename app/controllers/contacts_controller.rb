class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @contacts = current_org.contacts
    if params[:name].present? || params[:email].present?
      @contacts = @contacts.name_or_email_search(params[:name], params[:email])
    end    
    @contacts = @contacts.paginate(page: params[:page], per_page: 5).order('updated_at DESC')
  end

  def show
  end

  def new
    @contact = current_org.contacts.new
  end

  def edit
  end

  def create
    @contact = current_org.contacts.new(contact_params)
    if @contact.save
      flash.now[:success] = 'Contact was successfully created.'
      load_contacts
    end
  end

  def update
    if @contact.update(contact_params)
      flash.now[:success] = 'Contact was successfully updated.'
      load_contacts
    end
  end

  def destroy
    if @contact.destroy
      flash.now[:success] = 'Contact was successfully destroyed.'
    else
      flash.now[:danger] = 'Contact could not be destroyed.'
    end
    load_contacts
  end

  def import_contacts
    errors = Contact.import(params[:import], current_org.id)
    if errors.blank?
      flash[:success] = "Contacts Successfully Imported."
    else
      flash[:danger] = "Contacts could not be imported from file. <br/>" + errors.join("<br/>")
    end
    redirect_back fallback_location: contacts_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = current_org.contacts.where(id: params[:id]).first
  end
  
  def load_contacts
    @contacts = current_org.contacts.paginate(page: params[:page], per_page: 5).order('updated_at DESC')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number_1, :phone_number_2, :address_line_1,
                                    :address_line_2, :city_state_zip, :fax, :business_unit_id,
                                    :website, :contact_category_id, :title, :cell_phone, :notes, :project_id, :company_id)
  end
end
