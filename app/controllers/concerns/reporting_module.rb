module ReportingModule

  def generate_periodic_report(type, start_date_or_year, end_date_or_compare, parameters, activity)
    aggregation_columns = %w(net_new_investment new_jobs retained_jobs)
    filter_business_type = type.present? ? {type: type} : {type_1: 'New Business', type_2: 'Existing Business'}
    @results = {}
    if(activity == 'yearly')
      @projects = current_org.projects.business_type(filter_business_type)
                      .filter_by_active_date(start_date_or_year.year.ago, DateTime.new(end_date_or_compare).end_of_year)
                      .includes(:project_type, :industry_type, :competition, :source, :elimination_reason)
    else
      @projects = current_org.projects.business_type(filter_business_type)
                      .filter_by_active_date(start_date_or_year, end_date_or_compare)
                      .includes(:project_type, :industry_type, :competition, :source, :elimination_reason)
    end
    parameters.each do |param|
      @results[param] = @projects.group_by { |p| p.active_date.year }
      @results[param].each do |key, values|
        if aggregation_columns.include?(param)
          @results[param][key] = values.sum { |p| p[param] }
        else
          @results[param][key] = values.group_by { |p| p[param] }
        end
      end
    end
  end

  def download_report(report_format, activity)
    if (report_format == 'pdf')
      pdf = WickedPdf.new.pdf_from_string(as_html)
      save_path = Rails.root.join('public', "#{activity}_report.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      send_file("#{Rails.root}/public/#{activity}_report.pdf", type: "application/pdf", :disposition => 'attachment')
    else
      respond_to do |format|
        format.xls
      end
    end
  end

  def download_sites_or_projects(type, start_date, end_date, commit)
    start_date = Date.strptime(start_date, '%m/%d/%Y')
    end_date = Date.strptime(end_date, '%m/%d/%Y')
    if start_date < end_date
      if(commit == 'filter')
        redirect_to sites_reports_path(start_date: start_date, end_date: end_date) if type == 'sites'
        redirect_to projects_reports_path(start_date: start_date, end_date: end_date) if type == 'projects'
      else
        if(type == 'sites')
          @sites = current_org.sites.filter_by_date(start_date, end_date).includes(:project_sites)
          respond_to do |format|
            format.xls { headers["Content-Disposition"] = "attachment; filename='building_referrals_data.xls'" }
          end
        else
          generate_project_data(start_date, end_date)
          respond_to do |format|
            format.xls { headers["Content-Disposition"] = "attachment; filename='successful_project_data.xls'" }
          end
        end
      end
    else
      flash[:danger] = "Start Date should be before End Date."
      redirect_to sites_reports_path if type == 'sites'
      redirect_to projects_reports_path if type == 'projects'
    end
  end

  def generate_project_data(start_date, end_date)
    projects = current_org.projects.includes(:sites)
    if(start_date != nil && end_date != nil)
      projects = projects.where("projects.active_date >= ? AND projects.active_date <= ?", start_date, end_date)
    end
    @business_types = projects.group_by { |p| p.business_type }
    @total_buildings = projects.joins(:sites).group("project_sites.project_id").count.values.sum
    @new_business = @business_types['New Business'] == nil ? [0,0,0] : @business_types['New Business'].pluck(:new_jobs, :wages, :net_new_investment).transpose.map(&:sum)
    @existing_business = @business_types['Existing Business'] == nil ? [0,0,0] : @business_types['Existing Business'].pluck(:new_jobs, :wages, :net_new_investment).transpose.map(&:sum)
  end
  
end