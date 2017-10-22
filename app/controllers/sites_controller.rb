class SitesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  before_action :set_organization, except: [:destroy]

  # GET /sites
  # GET /sites.json
  def index
    redirect_to dashboard_index_path, notice: "You Cannot see other organization's sites/ buildings." if @organization != current_user.organization

    if params[:property_name].blank? && params[:property_number].blank? && params[:zip_code].blank?

      @sites = @organization.sites.paginate(:page => params[:page], :per_page => 2)

    else

      @sites = Site.property_number_or_propery_name_or_zip_code_search(@organization.id,
                                                                       params[:property_number], params[:property_name],
                                                                       params[:zip_code]).paginate(:page => params[:page], :per_page => 2)
    end

  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    respond_to do |format|
      format.js
    end
  end

  # GET /sites/new
  def new
    @site = Site.new
    respond_to do |format|
      format.js
    end
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites
  # POST /sites.json
  def create

    @site = @organization.sites.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to organization_sites_path(@organization, @site), notice: 'Site/ Building was successfully updated.' }
        format.json { render :show, status: :created, location: @site }
      else
        format.html { render :new }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to organization_sites_path(@organization, @site), notice: 'Site/ Building was successfully updated.' }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url, notice: 'Site was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def find_contact
    @contacts = @organization.contacts.where("name ilike ? or email ilike ?", "%#{params[:q]}%", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render :json => @contacts.map(&:attributes) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    # Set Organization
    def set_organization
      @organization = Organization.find(params[:organization_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_params
      params.require(:site).permit(:organization_id, :contact_id, :property_number, :property_name, :property_type, :address_line, :city,
                                   :state, :zip_code, :country, :available_acreage, :available_square_feet, :contact_id,
                                   :total_acreage, :total_square_feet, :latitude, :longitude, :business_unit)
    end
end
