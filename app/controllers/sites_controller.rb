class SitesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy]

  def index
    @sites = current_org.sites
    if params[:property_name].present? || params[:property_number].present? || params[:zip_code].present?
      @sites = @sites.property_number_or_property_name_or_zip_code_search(params[:property_number], params[:property_name],params[:zip_code])
    end
      @sites = @sites.paginate(page: params[:page], per_page: Site::PAGINATION[:per_page])
  end

  def show
    respond_to do |format|
      format.js
    end
  end


  def new
    @site = current_org.sites.new
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def create
    @site = current_org.sites.new(site_params)

    respond_to do |format|
      if @site.save
        flash.now[:success] = 'Site/ Building was successfully created.'
        load_sites
      else
        flash.now[:info] = 'Site could not be created, Please try again.'
        load_sites
      end
      format.js
    end
  end

  def update
    respond_to do |format|
      if @site.update(site_params)
        flash.now[:success] = 'Contact was successfully updated.'
        load_sites
      else
        flash.now[:info] = 'Site could not be updated, Please try again.'
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @site.destroy
        flash.now[:success] = 'Site was successfully destroyed.'
      else
        flash.now[:info] = 'Site could not be destroyed.'
      end
      load_sites
      format.js
    end
  end

  def find_contact
    @contacts = current_org.contacts.where('name ilike ? or email ilike ?', "%#{params[:q]}%", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render :json => @contacts.map(&:attributes) }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = current_org.sites.where(id: params[:id]).first
  end

  def load_sites
    @sites = current_org.sites.paginate(page: params[:page], per_page: Site::PAGINATION[:per_page]).order('updated_at DESC')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    params.require(:site).permit(:organization_id, :contact_id, :property_number, :property_name, :property_type, :address_line, :city,
                                 :state, :zip_code, :country, :available_acreage, :available_square_feet, :contact_id,
                                 :total_acreage, :total_square_feet, :latitude, :longitude, :business_unit)
  end
end
