# Manage sites/buildings belonging an organziation
class SitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_site, only: %i[show edit update destroy]
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @sites = current_org.sites
    filtering_params(params).each do |key, value|
      @sites = @sites.public_send(key, value) if value.present?
    end
    @sites = @sites.paginate(page: params[:page], per_page: 8)
                   .order('updated_at DESC')
  end

  def show; end

  def new
    @site = current_org.sites.new
  end

  def edit; end

  def create
    @site = current_org.sites.new(site_params)
    return unless @site.save
    flash.now[:success] = 'Site/ Building was successfully created.'
    load_sites
  end

  def update
    return unless @site.update(site_params)
    flash.now[:success] = 'Contact was successfully updated.'
    load_sites
  end

  def destroy
    return unless @site.destroy
    flash.now[:success] = 'Site was successfully destroyed.'
    load_sites
  end

  def import_sites
    errors = Site.import(params[:import], current_org.id)
    if errors.blank?
      flash[:success] = 'Sites Successfully Imported.'
    else
      flash[:danger] = 'Sites could not be imported from file.
                        <br/>' + errors.join('<br/>')
    end
    redirect_back fallback_location: sites_path
  end

  def find_contact
    @contacts = current_org.contacts.where('name ilike ? or email ilike ?',
                                           "%#{params[:q]}%", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render json: @contacts.map(&:attributes) }
    end
  end

  def check_sites_number_validity
    assign_message_and_status_for_id_validity('sites')
  end
  
  private

  def set_site
    @site = current_org.sites.where(id: params[:id]).first
    return unless @site.blank?
    flash[:notice] = 'Site not found.'
    redirect_to sites_path
  end

  def load_sites
    @sites = current_org.sites.paginate(page: params[:page], per_page: 8)
                        .order('updated_at DESC')
  end

  def site_params
    params.require(:site).permit(:organization_id, :contact_id, :site_number,
                                 :name, :property_type, :address_line,
                                 :city, :state, :zip_code, :country,
                                 :available_acreage, :available_square_feet,
                                 :contact_id, :total_acreage,
                                 :total_square_feet, :latitude, :longitude,
                                 :business_unit_id, :project_id,
                                 :special_district)
  end

  def filtering_params(params)
    params.slice(:property_name, :site_number, :zip_code)
  end
end
