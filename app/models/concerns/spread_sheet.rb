module SpreadSheet

  def self.included(base)
    base.extend ClassMethods
  end

  def add_errors(index, error_messages)
    unless self.valid?
      self.errors.full_messages.each do |message|
        error_messages << "Row #{index}: #{message}"
      end
    end
  end  
  
  module ClassMethods

    def get_spreadsheet_and_organization(import_params, current_org_id)
      spreadsheet = open_spreadsheet(import_params[:file])
      current_org = Organization.where(id: current_org_id).first
      return spreadsheet, current_org
    end

    def open_spreadsheet(file)
      case File.extname(file.original_filename)
        when ".csv" then Roo::CSV.new(file.path)
        when ".xls" then Roo::Excel.new(file.path)
        when ".xlsx" then Roo::Excelx.new(file.path)
        else raise "Unknown File Type: #{file.original_filename}"
      end
    end
  end

end