class ReportsController < ApplicationController

  before_action :authenticate_user!
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @selected_parameters = %w(status square_feet_requested acres_requested project_type_id industry_type_id source_id elimination_reason_id competition_id net_new_investment new_jobs retained_jobs)
    generate_report(params[:type], 3, 2017, @selected_parameters)
  end

  def download_report
    @selected_parameters = params[:report_params].keys + ["new_jobs", "retained_jobs"]
    generate_report(params[:type], params[:years_to_compare].to_i, params[:year].to_i, @selected_parameters)

    if (params[:format] == 'pdf')
      pdf = WickedPdf.new.pdf_from_string(as_html)
      save_path = Rails.root.join('public', 'yearly_report.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      send_file("#{Rails.root}/public/yearly_report.pdf", type: "application/pdf")
    else
      stream = render_to_string(:template => "reports/download_report.xls.erb")
      save_path = Rails.root.join('public', 'yearly_report.xls')
      File.open(save_path, 'wb') do |file|
        file << stream
      end
      send_file("#{Rails.root}/public/yearly_report.xls", type: 'application/xls; charset=UTF-8')
    end

    head :ok
  end

  def generate_report(type, compare_year = 3, compare_from_year = 2017, parameters)
    aggregation_columns = %w(net_new_investment new_jobs retained_jobs)
    filter_business_type = type.present? ? {type: type} : {type_1: 'New Business', type_2: 'Existing Business'}
    @results = {"years_to_compare": compare_year}
    @projects = current_org.projects.business_type(filter_business_type).filter_by_creation(compare_year.year.ago, DateTime.new(compare_from_year).end_of_year)
                    .includes(:project_type, :industry_type, :competition, :source, :elimination_reason)
    parameters.each do |param|
      @results[param] = @projects.group_by { |p| p.created_at.year }
      @results[param].each do |key, values|
        if aggregation_columns.include?(param)
          @results[param][key] = values.sum { |p| p[param] }
        else
          @results[param][key] = values.group_by { |p| p[param] }
        end
      end
    end
  end

  private

  attr_reader :results

  def as_html
    render template: "reports/generate_pdf.html.erb", layout: false, locals: {results: results},
           header: {
               content: render_to_string('reports/pdf_header.html.erb', layout: false)
           }
  end

end
