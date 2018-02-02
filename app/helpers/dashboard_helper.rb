module DashboardHelper

  require 'json'

  def get_project_types(results)
    filtered_project_types = results['project_type_id'].keys
        .inject({}) {|sum, n| sum.merge(results['project_type_id'][n]) {|key, v1, v2| v1+v2} }
        .sort_by {|key, val| val.count}.reverse.first(4)

    project_types_to_show = filtered_project_types.collect{|type| type[0]}
    seriesList = []
    labels = current_org.project_types.filter_by_id(project_types_to_show).pluck(:name)
    results['project_type_id'].keys.each do |year|
      series = []
      project_types_to_show.each do |type_id|
        series.push(results['project_type_id'][year][type_id].try(:length) || 0)
      end
      seriesList.push({name: 'Year: ' + year.to_s, data: series})
    end
    # return seriesList.to_json
    return {labels: labels, data: seriesList}.to_json
  end

  def dashboard_generic_prospect_total(results)
    seriesList = Project::STATUS.collect { |obj| {name: obj, y: 0.0} }
    results['status'].keys.each do |year|
      Project::STATUS.each do |obj|
        if series = seriesList.find {|data| data[:name] == obj}
          series[:y] += results['status'][year][obj].try(:length) || 0
        end
      end
    end
    seriesList.delete_if { |h| h[:y] == 0 }
    total_projects = seriesList.inject(0.0){|sum, elm| sum + elm[:y]}
    seriesList = seriesList.each { |elm| elm[:y] = (elm[:y]/total_projects).round(2) }.sort_by {|elm| elm[:y]}
    if seriesList.present?
      seriesList.last[:sliced] = true
      seriesList.last[:selected] = true
    end
    return seriesList.to_json
  end

  def dashboard_industry_report(data)
    grouped_result = data.values.collect { |year| year.values }.flatten
                         .select { |p| p if p.business_type == "New Business" }
                         .group_by {|p| p.industry_type_id}
    seriesList = grouped_result.collect { |obj| {name: '', y: 0.0} }
    total_projects = grouped_result.inject(0.0) { |result, obj| result + obj[1].count }
    grouped_result.keys.each_with_index do |industry_id, indx|
      seriesList[indx][:name] = current_org.industry_types.find(industry_id).name
      each_value = grouped_result[industry_id].count
      seriesList[indx][:y] = (each_value/total_projects).round(2)
    end
    seriesList.sort_by {|elm| elm[:y]}
    if seriesList.present?
      seriesList.last[:sliced] = true
      seriesList.last[:selected] = true
    end
    return seriesList.to_json
  end

end
