class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def index
    @contacts = current_org.contacts
    if params[:name].present? || params[:email].present?
      @contacts = @contacts.name_or_email_search(params[:name], params[:email])
    end    
    @contacts = @contacts.paginate(page: params[:page], per_page: 5)
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def new
    @contact = current_org.contacts.new
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def create
    @contact = current_org.contacts.new(contact_params)

    respond_to do |format|
      if @contact.save
        flash.now[:success] = 'Contact was successfully created.'
        load_contacts
      end
      format.js
    end
  end

  def update
    respond_to do |format|
      if @contact.update(contact_params)
        flash.now[:success] = 'Contact was successfully updated.'
        load_contacts
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @contact.destroy
        flash.now[:success] = 'Contact was successfully destroyed.'
      else
        flash.now[:info] = 'Contact could not be destroyed.'
      end
      load_contacts
      format.js
    end
  end

  def import_contacts
    file_data = params[:import][:file]
    if (!file_data.nil? && file_data.content_type.include?("csv"))
      counter = 0
      File.foreach(file_data.path).with_index do |line|
        contact = generate_contact(line, params[:import][:category], params[:import][:business_unit])
        begin
          contact.save
          counter += 1
        rescue
          next
        end
      end
      redirect_to contacts_path, notice: "#{counter} Contact/s imported Successfully!"
    else
      redirect_to contacts_path, notice: "Upload CSV with given format!"
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = current_org.contacts.where(id: params[:id]).first
  end
  
  # this method should be in any model related to this task. need to move !
  def generate_contact(contact, category, bussiness_unit)
    contact_info = contact.split(",")
    Contact.new(name: contact_info[0], organization_id: current_org.id, title: contact_info[2], address_line_1: contact_info[3],
                address_line_2: contact_info[4], city_state_zip: contact_info[5], phone_number_1: contact_info[6],
                phone_number_2: contact_info[7], cell_phone: contact_info[8], fax: contact_info[9], email: contact_info[10],
                website: contact_info[11], notes: contact_info[12], category: category, business_unit: bussiness_unit)
  end

  def load_contacts
    @contacts = current_org.contacts.paginate(page: params[:page], per_page: 5)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number_1, :phone_number_2, :address_line_1,
                                    :address_line_2, :city_state_zip, :fax, :business_unit,
                                    :website, :category, :title, :cell_phone, :notes)
  end
end
