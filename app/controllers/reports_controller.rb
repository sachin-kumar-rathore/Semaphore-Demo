class ReportsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_selected_parameters, only: [:index, :yearly, :monthly]
  before_action :predefined_parameters, only: [:yearly_report, :monthly_report]
  respond_to :html, only: [:index]
  respond_to :js

  def index

  end

  def yearly
    if(params[:year])
      generate_periodic_report(params[:type], params[:year_to_compare].to_i, params[:year].to_i, @selected_parameters, 'yearly')
    else
      generate_periodic_report(params[:type], 3, Date.today.year, @selected_parameters, 'yearly')
    end
  end

  def monthly
    if(params[:start_date])
      generate_periodic_report(params[:type], params[:start_date], params[:end_date], @selected_parameters, 'monthly')
    else
      generate_periodic_report(params[:type], Date.today.to_date - 30, Date.today, @selected_parameters, 'monthly')
    end
  end

  def yearly_report
    @selected_parameters = params[:report_params].keys + ["new_jobs", "retained_jobs"]
    generate_periodic_report(params[:type], params[:years_to_compare].to_i, params[:year].to_i, @predefined_parameters, 'yearly')
    download_report(params[:report_format], 'yearly')
  end

  def monthly_report
    @selected_parameters = params[:report_params].keys + ["new_jobs", "retained_jobs"]
    generate_periodic_report(params[:type], params[:start_date], params[:end_date], @predefined_parameters, 'monthly')
    download_report(params[:report_format], 'monthly')
  end

  def generate_periodic_report(type, start_date_or_year, end_date_or_compare, parameters, activity)
    aggregation_columns = %w(net_new_investment new_jobs retained_jobs)
    filter_business_type = type.present? ? {type: type} : {type_1: 'New Business', type_2: 'Existing Business'}
    @results = {}
    if(activity == 'yearly')
      @projects = current_org.projects.business_type(filter_business_type)
          .filter_by_active_date(start_date_or_year.year.ago, DateTime.new(end_date_or_compare).end_of_year)
          .includes(:project_type, :industry_type, :competition, :source, :elimination_reason)
    else
      @projects = current_org.projects.business_type(filter_business_type)
          .filter_by_active_date(start_date_or_year, end_date_or_compare)
          .includes(:project_type, :industry_type, :competition, :source, :elimination_reason)
    end
    parameters.each do |param|
      @results[param] = @projects.group_by { |p| p.active_date.year }
      @results[param].each do |key, values|
        if aggregation_columns.include?(param)
          @results[param][key] = values.sum { |p| p[param] }
        else
          @results[param][key] = values.group_by { |p| p[param] }
        end
      end
    end
  end

  def download_report(report_format, activity)
    if (report_format == 'pdf')
      pdf = WickedPdf.new.pdf_from_string(as_html)
      save_path = Rails.root.join('public', "#{activity}_report.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      send_file("#{Rails.root}/public/#{activity}_report.pdf", type: "application/pdf", :disposition => 'attachment')
    else
      respond_to do |format|
        format.xls
      end
    end
  end

  def sites
    if(params[:start_date])
      @sites = current_org.sites.filter_by_date(params[:start_date], params[:end_date]).includes(:project_sites)
          .paginate(page: params[:page], per_page: 5).order('updated_at DESC')
    else
      @sites = current_org.sites.includes(:project_sites).paginate(page: params[:page], per_page: 5).order('updated_at DESC')
    end
  end

  def download_sites
    download_sites_or_projects('sites', params[:start_date], params[:end_date], params[:commit])
  end

  def projects
    if(params[:start_date])
      generate_project_data(params[:start_date], params[:end_date])
    else
      generate_project_data(nil, nil)
    end
  end

  def download_projects
    download_sites_or_projects('projects', params[:start_date], params[:end_date], params[:commit])
  end

  def download_sites_or_projects(type, start_date, end_date, commit)
    start_date = Date.strptime(start_date, '%m/%d/%Y')
    end_date = Date.strptime(end_date, '%m/%d/%Y')
    if start_date < end_date
      if(commit == 'filter')
        redirect_to sites_reports_path(start_date: start_date, end_date: end_date) if type == 'sites'
        redirect_to projects_reports_path(start_date: start_date, end_date: end_date) if type == 'projects'
      else
        if(type == 'sites')
          @sites = current_org.sites.filter_by_date(start_date, end_date).includes(:project_sites)
          respond_to do |format|
            format.xls { headers["Content-Disposition"] = "attachment; filename='building_referrals_data.xls'" }
          end
        else
          generate_project_data(start_date, end_date)
          respond_to do |format|
            format.xls { headers["Content-Disposition"] = "attachment; filename='successful_project_data.xls'" }
          end
        end
      end
    else
      flash[:danger] = "Start Date should be before End Date."
      redirect_to sites_reports_path if type == 'sites'
      redirect_to projects_reports_path if type == 'projects'
    end
  end

  private

  def as_html
    render_to_string(template: "reports/generate_pdf.html.erb", layout: false)
  end

  def generate_project_data(start_date, end_date)
    projects = current_org.projects.includes(:sites)
    if(start_date != nil && end_date != nil)
      projects = projects.where("projects.active_date >= ? AND projects.active_date <= ?", start_date, end_date)
    end
    @business_types = projects.group_by { |p| p.business_type }
    @total_buildings = projects.joins(:sites).group("project_sites.project_id").count.values.sum
    @new_business = @business_types['New Business'] == nil ? [0,0,0] : @business_types['New Business'].pluck(:new_jobs, :wages, :net_new_investment).transpose.map(&:sum)
    @existing_business = @business_types['Existing Business'] == nil ? [0,0,0] : @business_types['Existing Business'].pluck(:new_jobs, :wages, :net_new_investment).transpose.map(&:sum)
  end

  def set_selected_parameters
    @selected_parameters = %w(status square_feet_requested acres_requested project_type_id industry_type_id source_id
                              elimination_reason_id competition_id net_new_investment new_jobs retained_jobs)
  end

  def predefined_parameters
    @predefined_parameters = %w(status square_feet_requested acres_requested project_type_id industry_type_id source_id
                                elimination_reason_id competition_id net_new_investment new_jobs retained_jobs)
  end

end
