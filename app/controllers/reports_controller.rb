class ReportsController < ManageGeneralModulesController
  before_action :change_format, only: [:yearly_report, :monthly_report]
  before_action :set_selected_parameters, only: [:index, :yearly, :monthly]
  respond_to :html, only: [:index]
  respond_to :js

  include ReportingModule

  def index
  end

  def highcharts
  end

  def highchart_report
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "highchart_report"   # Excluding ".pdf" extension.
      end
    end
  end

  def yearly
    generate_periodic_report('yearly')
  end

  def monthly
    generate_periodic_report('monthly')
  end

  # def highchart_report
  #   download_report('highcharts')
  # end
  
  def yearly_report
    @selected_parameters = params[:report_params].keys + ["new_jobs", "retained_jobs"]
    generate_periodic_report('yearly')
    download_report('yearly')
  end

  def monthly_report
    @selected_parameters = params[:report_params].keys + ["new_jobs", "retained_jobs"]
    generate_periodic_report('monthly')
    download_report('monthly')
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
    download_sites_or_projects('sites')
  end

  def projects
    generate_project_data(params[:start_date], params[:end_date])
  end

  def download_projects
    download_sites_or_projects('projects')
  end

  private

  def as_html
    render_to_string(template: "reports/generate_pdf.html.erb", layout: false)
  end

  def set_selected_parameters
    @selected_parameters = %w(status square_feet_requested acres_requested project_type_id industry_type_id source_id
                              elimination_reason_id competition_id net_new_investment new_jobs retained_jobs)
  end

  def change_format
    request.format = params[:format]
  end

end
