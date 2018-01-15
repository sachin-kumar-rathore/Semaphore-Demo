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
        {name: 'Prospects by Type (year to year comparison)', field: 'project_type_id_comp'},
        {name: 'Industry Type (year to year comparison)', field: 'industry_type_id_comp'},
        {name: 'Prospect Lead Sources (year to year comparison)', field: 'source_id_comp'},
        {name: 'Reasons or Project Elimination (year to year comparison)', field: 'elimination_reason_id_comp'}
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

  def get_generic_prospect_total(results, type, parameters)
    seriesList = parameters.collect { |obj| {meta: obj, value: 0} }
    results[type].keys.each do |year|
      parameters.each do |obj|
        if series = seriesList.find {|data| data[:meta] == obj}
          series[:value] += results[type][year][obj].try(:length) || 0
        end
      end
    end
    seriesList.delete_if { |h| h[:value] == 0 }
    return seriesList.to_json
  end

  def get_new_industry_report(data)
    grouped_result = data.values.collect { |year| year.values }.flatten
        .select { |p| p if p.business_type == "New Business" }
        .group_by {|p| p.industry_type_id}
    seriesList = grouped_result.collect { |obj| {meta: '', value: 0, percentage: 0.0} }
    total_projects = grouped_result.inject(0.0) { |result, obj| result + obj[1].count }
    grouped_result.keys.each_with_index do |industry_id, indx|
      seriesList[indx][:meta] = current_org.industry_types.find(industry_id).name
      seriesList[indx][:value] = grouped_result[industry_id].count
      seriesList[indx][:percentage] = (seriesList[indx][:value]/total_projects).round(2)
    end
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

  def filter_date(date)
    date.nil? ? nil : DateTime.parse(date).strftime("%m/%d/%Y")
  end

end
