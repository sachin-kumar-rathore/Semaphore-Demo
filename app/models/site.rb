require 'searchable'

class Site < ApplicationRecord
  include SpreadSheet
  include Searchable
  include Auditable

  IMPORT_PARAMETERS = ["site_number", "name", "contact_id", "property_type", "address_line",
                      "city", "country", "state", "zip_code", "special_district", "available_acreage", "available_square_feet",
                      "total_acreage", "total_square_feet", "latitude", "longitude"]
  attr_accessor :project_id
  # == Constants == #
  self.per_page = 5

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #

  # == Associations and Nested Attributes == #
  belongs_to :organization
  has_many :project_sites, dependent: :destroy
  has_many :projects, through: :project_sites
  belongs_to :business_unit
  # == Validations == #
  validates_presence_of :organization_id, :name, :site_number, :property_type, :address_line, :city, :state,
                        :zip_code, :country

  validates :available_acreage, presence:true, numericality: {only_float: true}
  validates :available_square_feet, presence:true, numericality: {only_float: true}
  validates :total_acreage, presence:true, numericality: {only_float: true}
  validates :total_square_feet, presence:true, numericality: {only_float: true}
  validates :latitude, presence:true, numericality: {only_float: true}
  validates :longitude, presence:true, numericality: {only_float: true}
  validates :site_number, uniqueness: true, presence: true, length: { is: 6 }
  validates :state, length: { is: 2 }
  validates :zip_code, length: { is: 5 }

  # == Callbacks == #
  after_create :add_site_to_project, if: :has_project_id?
  # == Scopes and Other macros == #
  scope :property_name, -> (property_name) { where("name ilike ?","%#{property_name}%")}
  scope :site_number, -> (site_number) { where("site_number = ?",site_number)}
  scope :zip_code, -> (zip_code) { where("zip_code = ?",zip_code)}
  scope :filter_by_date, -> (start_date, end_date) { where("created_at >= ? AND created_at <= ?", start_date, end_date)}
  # == Instance methods == #
  
  def self.import(import_params, current_org_id)
    error_messages = []
    sites = []
    begin
      spreadsheet, current_org = get_spreadsheet_and_organization(import_params, current_org_id) 
      Site.transaction do
        (1..spreadsheet.last_row).each do |index|
          site = new
          email = spreadsheet.cell(index, 3)
          site.attributes = Hash[Site::IMPORT_PARAMETERS.each_with_index.collect{ |item,i| [item, spreadsheet.cell(index,i+1)] }]
            .merge(organization_id: current_org_id,business_unit_id: import_params[:business_unit_id])
          assign_contact(current_org, site, import_params, email)
          site.handle_string_data_type
          sites << site
          site.add_errors(index, error_messages)
        end
        sites.map(&:save) if error_messages.blank?
        raise ActiveRecord::Rollback, "Deleting Contacts........." if !error_messages.blank?
      end
    rescue Exception => e
      error_messages << e
    end
    error_messages 
  end

  # == Private == #
  def add_site_to_project
    project_sites.create!(project_id: project_id)
  end

  def has_project_id?
    project_id.present?    
  end
  
  def handle_string_data_type
    self.site_number = self.site_number.to_i.to_s
    self.zip_code = self.zip_code.to_i.to_s    
  end

  def self.assign_contact(current_org, site, import_params, email)
    contact = current_org.contacts.where(email: email).first_or_initialize
    contact.save(validate: false) if(import_params[:create_new_contacts] && contact.new_record?)
    site[:contact_id] = contact.id
  end
end
