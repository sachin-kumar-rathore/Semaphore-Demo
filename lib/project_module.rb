module ProjectModule
  include DateParser

  def convert_site_visit_dates
    begin
      site_visits_attributes = params[:project][:site_visits_attributes]
      if site_visits_attributes.present?
        site_visits_attributes.keys.each do |key|
          site_visits_attributes[key]['visit_date'] = convert_date(site_visits_attributes[key]['visit_date']) if site_visits_attributes[key]['visit_date'].present?
        end
      end
    rescue StandardError
      nil
    end
  end
end