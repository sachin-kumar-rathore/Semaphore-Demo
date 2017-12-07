class ReportsController < ApplicationController

  before_action :authenticate_user!
  respond_to :html, only: [:index]
  respond_to :js

  def index
    generate_report(params[:type], 3)
  end

  def generate_pdf
    generate_report(params[:type], 3)
    kit = PDFKit.new(as_html, page_size: 'A4')
    kit.to_file("#{Rails.root}/public/report.pdf")
  end

  def generate_xsl

  end

  def generate_report(type, compare_year = 3)
    filter_business_type = type.present? ? {type: type} : {type_1: 'New Business', type_2: 'Existing Business'}
    @results = {"years_to_compare": compare_year}
    parameters = %w(status square_feet_requested acres_requested project_type_id industry_type_id source_id elimination_reason_id net_new_investment new_jobs retained_jobs)
    @projects = current_org.projects.business_type(filter_business_type).includes(:project_type, :industry_type, :competition, :source, :elimination_reason)
        .where("created_at >= ? AND created_at <= ?", compare_year.year.ago, DateTime.new(2017).end_of_year)
    parameters.each_with_index do |param, indx|
      @results[param] = @projects.group_by { |p| p.created_at.year }
      @results[param].each do |key, values|
        if indx > 6
          @results[param][key] = values.sum { |p| p[param].to_i }
        else
          @results[param][key] = values.group_by { |p| p[param] }
        end
      end
    end
  end

  private

  attr_reader :results

  def as_html
    render template: "reports/generate_pdf.pdf", layout: false, locals: { results: results }
  end

end
