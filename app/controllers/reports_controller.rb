class ReportsController < ApplicationController

  before_action :authenticate_user!
  respond_to :html, only: [:index]
  respond_to :js

  def index
    @selected_parameters = %w(status square_feet_requested acres_requested project_type_id industry_type_id source_id elimination_reason_id competition_id net_new_investment new_jobs retained_jobs)
    if(params[:period] == 'yearly')
      generate_yearly_report(params[:type], 3, 2017, @selected_parameters)
    else
      generate_monthly_report(params[:type], Date.today.to_date - 30, Date.today, @selected_parameters)
    end
  end

  def yearly_report
    @selected_parameters = params[:report_params].keys + ["new_jobs", "retained_jobs"]
    generate_yearly_report(params[:type], params[:years_to_compare].to_i, params[:year].to_i, @selected_parameters)

    if (params[:report_format] == 'pdf')
      pdf = WickedPdf.new.pdf_from_string(as_html)
      save_path = Rails.root.join('public', 'yearly_report.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      send_file("#{Rails.root}/public/yearly_report.pdf", type: "application/pdf", :disposition => 'attachment')
      head :ok
    else
      respond_to do |format|
        format.xls
      end
    end

  end

  def generate_yearly_report(type, compare_year = 3, compare_from_year = 2017, parameters)
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

  def monthly_report
    @selected_parameters = %w(status square_feet_requested acres_requested project_type_id industry_type_id source_id elimination_reason_id competition_id net_new_investment new_jobs retained_jobs)
    generate_monthly_report(params[:type], params[:start_date], params[:end_date], @selected_parameters)

    if (params[:report_format] == 'pdf')
      pdf = WickedPdf.new.pdf_from_string(as_html)
      save_path = Rails.root.join('public', 'monthly_report.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      send_file("#{Rails.root}/public/monthly_report.pdf", type: "application/pdf", :disposition => 'attachment')
      head :ok
    else
      respond_to do |format|
        format.xls
      end
    end
  end

  def generate_monthly_report(type, start_date, end_date, parameters)
    aggregation_columns = %w(net_new_investment new_jobs retained_jobs)
    filter_business_type = type.present? ? {type: type} : {type_1: 'New Business', type_2: 'Existing Business'}
    @results = {}
    @projects = current_org.projects.business_type(filter_business_type).filter_by_creation(start_date, end_date)
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
    render_to_string(template: "reports/generate_pdf.html.erb", layout: false, locals: {results: results})
  end

end
