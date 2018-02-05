module DashboardHelper

  require 'json'
  require 'faker'

  def get_project_types(results)
    filtered_project_types = results['project_type_id'].keys
        .inject({}) { |sum, n| sum.merge(results['project_type_id'][n]) { |key, v1, v2| v1+v2 } }
        .sort_by { |key, val| val.count }.reverse.first(4)

    project_types_to_show = filtered_project_types.collect { |type| type[0] }
    seriesList = list_of_project_types_to_show(results, project_types_to_show)
    labels = current_org.project_types.filter_by_id(project_types_to_show).pluck(:name)
    if @not_demo_mode
      return {labels: labels, data: seriesList}.to_json
    else
      return {labels: ['Waterhouse', 'Call Center', 'Manufacturing', 'Data Center'], data: load_demo_data['project_types']}.to_json
    end
  end

  def dashboard_generic_prospect_total(results)
    seriesList = Project::STATUS.collect { |obj| {name: obj, y: 0.0} }
    results['status'].keys.each do |year|
      Project::STATUS.each do |obj|
        if series = seriesList.find { |data| data[:name] == obj }
          series[:y] += results['status'][year][obj].try(:length) || 0
        end
      end
    end
    seriesList.delete_if { |h| h[:y] == 0 }
    total_projects = seriesList.inject(0.0) { |sum, elm| sum + elm[:y] }
    seriesList = seriesList.each { |elm| elm[:y] = (elm[:y]/total_projects).round(2) }.sort_by { |elm| elm[:y] }
    if seriesList.present?
      seriesList.last[:sliced] = true
      seriesList.last[:selected] = true
    end
    if @not_demo_mode
      return seriesList.to_json
    else
      return load_demo_data["project_status"].to_json
    end
  end

  def dashboard_industry_report(data)
    grouped_result = data.values.collect { |year| year.values }.flatten
        .select { |p| p if p.business_type == "New Business" }
        .group_by { |p| p.industry_type_id }
    seriesList = grouped_result.collect { |obj| {name: '', y: 0.0} }
    total_projects = grouped_result.inject(0.0) { |result, obj| result + obj[1].count }
    grouped_result.keys.each_with_index do |industry_id, indx|
      seriesList[indx][:name] = current_org.industry_types.find(industry_id).name
      each_value = grouped_result[industry_id].count
      seriesList[indx][:y] = (each_value/total_projects).round(2)
    end
    seriesList.sort_by { |elm| elm[:y] }
    if seriesList.present?
      seriesList.last[:sliced] = true
      seriesList.last[:selected] = true
    end
    if @not_demo_mode
      return seriesList.to_json
    else
      return load_demo_data["new_projects"].to_json
    end
  end

  def list_of_project_types_to_show(results, types)
    seriesList = []
    results['project_type_id'].keys.each do |year|
      series = []
      types.each do |type_id|
        series.push(results['project_type_id'][year][type_id].try(:length) || 0)
      end
      seriesList.push({name: 'Year: ' + year.to_s, data: series})
    end
    return seriesList
  end

  def load_demo_data
    file = File.read('lib/demo_data.json')
    data_hash = JSON.parse(file)
    return data_hash
  end

  def numbers_of_projects(object)
    if @projects.count > 0
      return object.try(:length)
    else
      return rand(10..100)
    end
  end

  def project_resources_total(object, resource)
    if @projects.count > 0
      return object ? object.pluck(resource).sum : 0
    else
      return resource == 'new_jobs' ? rand(10..100) : rand(50000..100000)
    end
  end

  def load_demo_tasks_emails(object)
    objects = []
    5.times do
      objects << Task.new(priority: Task::PRIORITY.sample, progress: rand(0..100), description: Faker::Lorem.sentence)
    end
    return objects
  end

end
