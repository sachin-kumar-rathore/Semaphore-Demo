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

  def get_generic_prospect_total_new(results, type, parameters)
    labels = results[type].keys
    seriesList = []
    parameters.each do |type_name|
      typeData = {data: []}
      results[type].keys.each do |year|
        typeData[:data] << {y: (results[type][year][type_name].nil? ? 0 : results[type][year][type_name].try(:length) || 0)}
      end
      typeData[:name] = type_name
      seriesList << typeData
    end
    return {labels: labels, data: seriesList}.to_json
  end

  def get_associated_types_total_new(results, type)
    reporting_parameter_objects = filter_model_rows(type)
    seriesList = list_of_prospect_type_totals_to_show(results, reporting_parameter_objects, type)
    total_projects = seriesList.inject(0.0) { |sum, elm| sum + elm[:y] }
    seriesList = seriesList.each { |elm| elm[:y] = (elm[:y]/total_projects).round(2) }.sort_by { |elm| elm[:y] }
    if seriesList.present?
      seriesList.last[:sliced] = true
      seriesList.last[:selected] = true
    end

    return seriesList.to_json
  end

  def list_of_prospect_type_totals_to_show(results, typeList, type)
    seriesList = typeList.collect { |obj| {name: obj.name, y: 0.0} }
    results[type].keys.each do |year|
      typeList.each do |obj|
        if series = seriesList.find { |data| data[:name] == obj.name }
          series[:y] += results[type][year][obj.id].try(:length) || 0
        end
      end
    end
    seriesList.delete_if { |h| h[:y] == 0 }
    return seriesList
  end

  def get_generic_types_comparison(results, type)
    generic_types = filter_model_rows(type)
    generic_types_to_show = generic_types.pluck(:id).sort
    seriesList = list_of_generic_types_comparison_to_show(results, generic_types_to_show, type)
    labels = generic_types.filter_by_id(generic_types_to_show).pluck(:name)
    return {labels: labels, data: seriesList}.to_json
  end

  def list_of_generic_types_comparison_to_show(results, generic_types, type)
    seriesList = []
    results[type].keys.each do |year|
      series = []
      generic_types.each do |type_id|
        series.push(results[type][year][type_id].try(:length) || 0)
      end
      seriesList.push({name: 'Year: ' + year.to_s, data: series})
    end
    return seriesList
  end

  def net_new_investment(results, type)
    seriesList = []
    typeData = {data: []}
    results[type].keys.each do |year|
      typeData[:data] << {y: results[type][year].to_f}
    end
    seriesList << typeData
    return {labels: results[type].keys, data: seriesList}.to_json
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
