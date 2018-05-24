class OutlookContactsController < ManageGeneralModulesController
  skip_before_action :authenticate_module!
  before_action :authorize_contacts_and_imports
  
  include AuthenticationModule

  def index
    respond_to do |format|
      format.html { import_outlook_contacts }
      format.js { load_temp_contacts }
    end 
  end

  def show
    @temp_contact = current_user.temp_contacts.find_by_email(params[:email])
  end

  def import_or_update_contact
    if params[:temp_contact_id]
      temp_contact = current_user.temp_contacts.find_by_id(params[:temp_contact_id])
      params[:discard] ? temp_contact.destroy : insert_or_modify_contact(temp_contact)
      flash.now[:success] = 'Request successfully processed.'
    else
      import_all_outlook_contacts
    end
  end

  private

  def import_outlook_contacts
    token = get_access_token
    if token.present?
      current_user.temp_contacts.destroy_all
      contacts = get_outlook_contacts(token)
      TempContact.insert_records(current_user, contacts)
      load_temp_contacts
    else
      @outlook_login_url = get_login_url
    end
  end

  def insert_or_modify_contact(temp_contact)
    contact = temp_contact.exist ? current_org.contacts.find_by_email(temp_contact.email)
                                 : current_org.contacts.new
    contact.attributes = contact.attributes.merge(temp_contact.filtered_attributes.select{|key, value| value.present?  })
    temp_contact.destroy if contact.save(validate: false)
  end

  def load_temp_contacts
    @contacts = current_user.temp_contacts
    paginate_temp_contacts
    (params[:page] = params[:page].to_i - 1) && paginate_temp_contacts if params[:page] && params[:page].to_i > 1 && @contacts.blank?
  end
  
  def paginate_temp_contacts
    @contacts = @contacts.paginate(page: params[:page], per_page: Contact::PAGINATION_VALUE)
  end

  def import_all_outlook_contacts
    current_user.temp_contacts.each do |temp_contact|
      insert_or_modify_contact(temp_contact)
    end
    flash.now[:success] = 'All contacts are successfully imported'
  end

  def authorize_contacts_and_imports
    authenticate_imports
    authenticate_contacts
  end

  def authenticate_contacts
    match_enabled_module('contacts') 
    verify_write_access('contacts')
  end
end
