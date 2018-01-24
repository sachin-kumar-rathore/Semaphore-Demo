class Autocompleter < Struct.new(:query)
  MODELS_TO_SEARCH = [Project, Contact, Site, Activity, Company, Task]

  def self.call(query)
    new(query).call
  end

  def call (org_id, user_ids)
    result_hash = {}
    MODELS_TO_SEARCH.each do |model_to_search|
      build_filter_string(model_to_search, org_id, user_ids)
      build_query
      result_hash[model_to_search.to_s.downcase.to_sym] = results(model_to_search).map do |record|
        {
          hint: build_hint(record),
          link: build_path(record),
          record_type: record.class.name,
          record_id: record.id
        }
      end
    end
    result_hash
  end

  private

  def results(model_to_search)     
    Elasticsearch::Model.search(@query, model_to_search).records
  end

  def build_hint(record)
    case record.class.to_s
    when "Project" then "Project Name: #{record.name}, Project Number: #{record.project_number}"
    when "Contact" then "Contact Name: #{record.name}, Email: #{record.email}"
    when "Site" then "Site Name: #{record.name}, Site Number: #{record.site_number}"
    when "Activity" then "Activity Name: #{record.name}, Activity Number: #{record.activity_number}"
    when "Company" then "Company Name: #{record.name}, Company Number: #{record.company_number}"
    #when "Document" then "Document Name: #{File.basename(record.name.to_s)}, Size: #{record.size} + 'kB'"
    when "Task" then "Task Name: #{record.name}, Description: #{record.description}"
    end
  end

  def build_path(record)
    case record.class.to_s
    when "Project" then "projects/#{record.id}/edit"
    when "Contact" then "contacts?id=#{record.id}"
    when "Site" then "sites?id=#{record.id}"
    when "Activity" then "activities/#{record.id}/edit"
    when "Company" then "companies/#{record.id}/edit"
    #when "Document" then "files?id=#{record.id}"
    when "Task" then "tasks?id=#{record.id}"
    end
  end

  def build_query
    @query = {
      "query": {
        "function_score": {
          "query": {
            "match": {
              "name": {
                "query": query,
                "operator": "and",
              }
            }
          },
          "filter": @filter_string
        }
      }
    }
  end

  def build_filter_string(model_to_search, org_id, user_ids)
    @filter_string = (model_to_search.to_s == 'Task') ? {"terms": { "user_id": user_ids }} : { "term": { "organization_id": org_id }}
  end
end
