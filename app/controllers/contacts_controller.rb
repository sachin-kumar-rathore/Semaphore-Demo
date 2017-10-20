class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :set_organization, except: [:destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    redirect_to dashboard_index_path, notice: "You Cannot see other organization's contacts." if @organization != current_user.organization
    if params[:name].blank? && params[:email].blank?
      @contacts = @organization.contacts.paginate(:page => params[:page], :per_page => 5)
    else
      @contacts = Contact.name_or_email_search(@organization.id, params[:name], params[:email]).paginate(:page => params[:page], :per_page => 5)
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    respond_to do |format|
      format.js
    end
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    respond_to do |format|
      format.js
    end
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = @organization.contacts.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to organization_contacts_path(@organization, @contact), notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to organization_contacts_path(@organization, @contact), notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
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
      redirect_to organization_contacts_path(@organization), :notice => "#{counter} Contact/s imported Successfully!"
    else
      redirect_to organization_contacts_path(@organization), :notice => "Upload CSV with given format!"
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def generate_contact(contact, category, bussiness_unit)
    contact_info = contact.split(",")
    Contact.new(name: contact_info[0], organization_id: @organization.id, title: contact_info[2], address_line_1: contact_info[3],
                address_line_2: contact_info[4], city_state_zip: contact_info[5], phone_number_1: contact_info[6],
                phone_number_2: contact_info[7], cell_phone: contact_info[8], fax: contact_info[9], email: contact_info[10],
                website: contact_info[11], notes: contact_info[12], category: category, business_unit: bussiness_unit)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number_1, :phone_number_2, :address_line_1,
                                    :address_line_2, :city_state_zip, :fax, :business_unit,
                                    :website, :category, :title, :cell_phone, :notes)
  end
end
