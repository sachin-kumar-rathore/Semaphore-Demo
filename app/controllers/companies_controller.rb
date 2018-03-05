# Manage companies inside an organization
class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, except: %i[index new]
  respond_to :html, only: %i[index edit]
  respond_to :js

  def index
    @companies = current_org.companies
    filtering_params(params).each do |key, value|
      @companies = @companies.public_send(key, value) if value.present?
    end
    @companies = @companies.paginate(page: params[:page], per_page: 8)
                           .order('companies.updated_at DESC')
  end

  def show; end

  def new
    @company = current_org.companies.new
  end

  def edit
    load_company_data
    return unless @company.blank?
    flash[:danger] = 'Company not found.'
    redirect_to companies_path
  end

  def create
    @company = current_org.companies.new(company_params)
    return unless @company.save
    flash.now[:success] = 'Company was successfully created.'
    load_companies
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

  def destroy
    if @company && @company.destroy
      flash[:success] = 'Company deleted successfully.'
    else
      flash[:danger] = 'Could not delete company.'
    end
    redirect_to companies_path
  end

  def check_companies_number_validity
    assign_message_and_status_for_id_validity('companies')
  end

  def export_form; end

  def export
    @companies = current_org.companies
    unless (params[:export_all] == 'true')
      filtering_params(params).each do |key, value|
        @companies = @companies.public_send(key, value) if value.present?
      end
    end
    if @companies.present?
      respond_to do |format|
        format.xls {
          response.headers['Content-Disposition'] = "attachment; filename=\"companyExport.xls\""
        }
      end
    else
      redirect_to export_form_companies_path
      flash[:danger] = 'No records are found'
    end
  end

  private

  def load_companies
    @companies = current_org.companies
                            .paginate(page: params[:page], per_page: 8)
                            .order('updated_at DESC')
  end

  def set_company
    @company = current_org.companies.where(id: params[:id]).first
  end

  def company_params
    params.require(:company).permit(:name, :company_number, :industry_type_id,
                                    :address_line_1, :address_line_2,
                                    :city, :state, :zip_code, :phone_number_1,
                                    :phone_number_2, :cell_phone, :fax,
                                    :website, :email).merge(organization_id:
                                    current_org.id)
  end

  def company_info_params
    params.require(:company).permit(:name, :company_number, :industry_type_id,
                                    :city, :state, :zip_code, :country,
                                    :region, :phone_number_1, :fax, :website,
                                    :email, :member_investor,
                                    :notes)
  end

  def history_params
    params.require(:company).permit(:company_establishment_year,
                                    :years_business_located)
  end

  def facilities_params
    params.require(:company).permit(:project_type_id, :acreage, :building_size,
                                    :number_of, :average_age_of_buildings,
                                    :room_for_expansion, :owned_or_leased,
                                    :lease_expiration_date_str, :facility_notes,
                                    :owner_id)
  end

  def products_and_services_params
    params.require(:company).permit(:primary_products_and_services, :naics_code_1,
                                    :naics_code_2, :naics_code_3, :naics_code_4,
                                    :naics_code_5)
  end

  def local_employment_params
    params.require(:company).permit(:full_time_employees, :part_time_employees,
                                    :leased_employees, :total_employees,
                                    :number_of_jobs_added_or_lost_in_past_3_years,
                                    :number_of_shifts_per_day,
                                    :number_of_days_per_week,
                                    :average_annual_salary,
                                    :date_of_total_str, :employment_notes)
  end

  def union_representation_params
    params.require(:company).permit(:business_union_represented,
                                    :employment_notes)
  end

  def update_form(form_params)
    return unless @company.update(form_params)
    return unless params[:commit].present?
    flash[:success] = 'Company was successfully updated.'
    respond_to do |format|
      format.js { render js: "window.location = '/companies';" }
    end
  end

  def filtering_params(params)
    params.slice(:industry_type_id, :company_name, :associated_project,
                 :associated_contact)
  end

  def load_company_data
    @company_contacts = @company.contacts
                                .paginate(page: params[:page], per_page: 8)
                                .order('updated_at DESC')
    @activities = @company.activities
                          .paginate(page: params[:page], per_page: 8)
                          .order('updated_at DESC')
    @company_projects = @company.projects
                                .paginate(page: params[:page], per_page: 8)
                                .order('updated_at DESC')
  end
end
