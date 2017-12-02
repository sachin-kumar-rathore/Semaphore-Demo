class ReportsController < ApplicationController

  before_action :authenticate_user!

  def index
    @results = {"years_to_compare": 3}
    parameters = %w(status project_type_id industry_type_id source_id elimination_reason_id net_new_investment new_jobs retained_jobs)
    @projects = current_org.projects.includes(:project_type, :industry_type, :competition, :source, :elimination_reason)
                    .where("created_at >= ? AND created_at <= ?", 3.year.ago, DateTime.new(2017).end_of_year)
    parameters.each_with_index do |param, indx|
      @results[param] = @projects.group_by{|p| p.created_at.year}
      @results[param].each do |key, values|
        if indx > 4
          @results[param][key] = values.sum{|p| p[param].to_i}
        else
          @results[param][key] = values.group_by{|p| p[param]}
        end
      end
    end
  end

  def generate_pdf

  end

  def generate_xsl

  end

  private
  def find_type_name(id, reference_column)
    case reference_column
      when "project_type_id"
        ProjectType.find(id).name
      when "industry_type_id"
        IndustryType.find(id).name
      when "source_id"
        Source.find(id).name
      when "elimination_reason_id"
        EliminationReason.find(id).name
      else
        reference_column
    end
  end

end
