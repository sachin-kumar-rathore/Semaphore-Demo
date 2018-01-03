class ReportsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_selected_parameters, only: [:index, :yearly, :monthly]
  before_action :predefined_parameters, only: [:yearly_report, :monthly_report]
  respond_to :html, only: [:index]
  respond_to :js

  include ReportingModule

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

  private

  def as_html
    render_to_string(template: "reports/generate_pdf.html.erb", layout: false)
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
