class CompaniesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_company, except: [:index, :new]
  respond_to :html, only: [:index, :edit]
  respond_to :js
     
  def index
    @companies = current_org.companies.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
  end

  def show
  end

  def new
    @company = current_org.companies.new
  end

  def edit
    if @company.blank?
      flash[:danger] = 'Company not found.'
      redirect_to companies_path
    end
  end

  def create
    @company = current_org.companies.new(company_params)
    if @company.save
      flash.now[:success] = 'Company was successfully created.'
      load_companies
    end
  end

  def company_info_update
    update_form(company_info_params)
  end

  def history_update
    update_form(history_params)
  end

  def facilities_update
    update_form(facilities_params)
  end

  def products_and_services_update
    update_form(products_and_services_params)
  end

  def local_employment_update
    update_form(local_employment_params)
  end

  def union_representation_update
    update_form(union_representation_params)
  end

  private
    
  def load_companies
    @companies = current_org.companies.paginate(page: params[:page], per_page: 8).order('updated_at DESC')
  end

  def set_company
    @company = current_org.companies.where(id: params[:id]).first
  end

  def company_params
    params.require(:company).permit(:name, :company_number, :business_sector, :title, :address_line_1,
                                    :address_line_2, :city_state_zip, :phone_number_1, :phone_number_2,
                                    :cell_phone, :fax, :website, :email).merge(organization_id: current_org.id)
  end

  def company_info_params
    params.require(:company).permit(:name, :company_number, :business_sector, :city, :state,
                                    :zip_code, :country, :region, :phone_number_1, :fax, :website,
                                    :email, :member_investor, :utility_provider_1, :utility_provider_2,
                                    :notes, :business_unit )
  end

  def history_params
    params.require(:company).permit(:company_establishment_year, :years_business_located)
  end

  def facilities_params
    params.require(:company).permit(:facility_type, :acreage, :building_size, :number_of, :average_age_of_buildings,
                                    :room_for_expansion, :owned_or_leased, :lease_expiration_date_str, :facility_notes)
  end

  def products_and_services_params
    params.require(:company).permit(:primary_products_and_services)
  end

  def local_employment_params
    params.require(:company).permit(:full_time_employees, :part_time_employees, :leased_employees,
                                    :total_employees, :number_of_jobs_added_or_lost_in_past_3_years,
                                    :number_of_shifts_per_day, :number_of_days_per_week, :average_annual_salary,
                                    :date_of_total_str, :employment_notes)
  end

  def union_representation_params
    params.require(:company).permit(:business_union_represented, :employment_notes)
  end

  def update_form(form_params)
    if @company.update(form_params)
      if params[:commit].present?
        flash[:success] = 'Company was successfully updated.'
        respond_to do |format|
          format.js {render js: "window.location = '/companies';"}
        end
      end
    end
  end
end
