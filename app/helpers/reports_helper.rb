module ReportsHelper

  require 'json'

  def report_parameters
    [
        {name: 'Business Prospects', field: 'status'}, # Business Prospect is the combination of all Project states
        {name: 'Prospects by Type', field: 'project_type_id'},
        {name: 'Industry Type', field: 'industry_type_id'},
        {name: 'Prospect Lead Sources', field: 'source_id'},
        {name: 'Reasons or Project Elimination', field: 'elimination_reason_id'},
        {name: 'Competition', field: 'competition_id'},
        {name: 'Prospect Acreage Request', field: 'acres_requested'},
        {name: 'Prospect Square foot Request', field: 'square_feet_requested'},
        {name: 'Total Number of New Jobs/Total New Investment', field: 'net_new_investment'},
        {name: 'Prospects by Type (year to year comparison)', field: 'project_type_id'},
        {name: 'Industry Type (year to year comparison)', field: 'industry_type_id'},
        {name: 'Prospect Lead Sources (year to year comparison)', field: 'source_id'},
        {name: 'Reasons or Project Elimination (year to year comparison)', field: 'elimination_reason_id'}
    ]
  end

  def get_associated_types(results, type)
    seriesList = []
    results[type].keys.each do |year|
      series = []
      filter_model_rows(type).pluck(:id).each do |obj|
        data = {meta: 'Year: ' + year.to_s, value: results[type][year][obj].try(:length) || 0}
        series.push(data)
      end
      seriesList.push(series)
    end
    return seriesList.to_json
  end

  def get_associated_types_total(results, type)
    reporting_parameter_objects = filter_model_rows(type)
    seriesList = reporting_parameter_objects.collect { |obj| {meta: obj.name, value: 0, id: obj.id} }
    results[type].keys.each do |year|
      reporting_parameter_objects.pluck(:id).each do |obj|
        if series = seriesList.find {|data| data[:id] == obj}
          series[:value] += results[type][year][obj].try(:length) || 0
        end
      end
    end
    seriesList.delete_if { |h| h[:value] == 0 }
    return seriesList.to_json
  end

  def get_business_prospect_total(results, type)
    seriesList = Project::STATUS.collect { |obj| {meta: obj, value: 0} }
    results[type].keys.each do |year|
      Project::STATUS.each do |obj|
        if series = seriesList.find {|data| data[:meta] == obj}
          series[:value] += results[type][year][obj].try(:length) || 0
        end
      end
    end
    seriesList.delete_if { |h| h[:value] == 0 }
    return seriesList.to_json
  end

  def filter_model_rows(reference_column)
    case reference_column
      when "project_type_id"
        current_org.project_types
      when "industry_type_id"
        current_org.industry_types
      when "source_id"
        current_org.sources
      when "elimination_reason_id"
        current_org.elimination_reasons
      else
        current_org.competitions
    end
  end

end
