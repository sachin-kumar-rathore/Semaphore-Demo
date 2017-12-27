class SitesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @sites = current_org.sites
    filtering_params(params).each do |key, value|
      @sites = @sites.public_send(key, value) if value.present?
    end
      @sites = @sites.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
  end

  def show
  end

  def new
    @site = current_org.sites.new
  end

  def edit
  end

  def create
    @site = current_org.sites.new(site_params)
    if @site.save
      flash.now[:success] = 'Site/ Building was successfully created.'
      load_sites
    end
  end

  def update
    if @site.update(site_params)
      flash.now[:success] = 'Contact was successfully updated.'
      load_sites
    end
  end

  def destroy
    if @site.destroy
      flash.now[:success] = 'Site was successfully destroyed.'
    end
    load_sites
  end

  def find_contact
    @contacts = current_org.contacts.where('name ilike ? or email ilike ?', "%#{params[:q]}%", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render :json => @contacts.map(&:attributes) }
    end
  end

  def check_sites_number_validity
    set_message_and_status_for_id_validity("sites")
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = current_org.sites.where(id: params[:id]).first
  end

  def load_sites
    @sites = current_org.sites.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    params.require(:site).permit(:organization_id, :contact_id, :site_number, :property_name, :property_type, :address_line, :city,
                                 :state, :zip_code, :country, :available_acreage, :available_square_feet, :contact_id,
                                 :total_acreage, :total_square_feet, :latitude, :longitude, :business_unit_id, :project_id)
  end

  def filtering_params(params)
    params.slice(:property_name, :site_number, :zip_code)
  end
  
end
