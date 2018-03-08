require 'roo'
require 'searchable'
class Contact < ApplicationRecord
  include SpreadSheet
  include Searchable
  include Auditable
  
  IMPORT_PARAMETERS = ["name", "title", "address_line_1", "address_line_2",
                      "city_state_zip", "phone_number_1", "phone_number_2", "cell_phone",
                      "fax", "email", "website", "notes"]
  PAGINATION_VALUE = 6
  attr_accessor :project_id, :company_id
  # == Constants == #
  self.per_page = 5

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #
  include PgSearch

  # == Associations and Nested Attributes == #
  belongs_to :organization
  has_many :project_contacts, dependent: :destroy
  has_many :projects, through: :project_contacts
  has_many :company_contacts, dependent: :destroy
  has_many :companies, through: :company_contacts
  has_and_belongs_to_many :emails
  has_many :contact_considered_locations, dependent: :destroy
  has_many :considered_locations, through: :contact_considered_locations
  has_many :companies, class_name: 'Company', foreign_key: :owner_id
  belongs_to :contact_category
  belongs_to :business_unit


  # == Validations == #
  validates_presence_of :name, :email
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Invalid"
  validates_uniqueness_of :email, scope: :organization_id
  validate  :linkedin_url_validator
  # == Callbacks == #
  after_create :add_contact_to_project, if: :has_project_id? 
  after_create :add_contact_to_company, if: :has_company_id?
  before_save :strip_linkedin_url
  # == Scopes and Other macros == #
  pg_search_scope :name_search, :against => :name, :using => {
      :tsearch => {:prefix => true}
  }
  pg_search_scope :email_search, :against => :email, :using => {
      :tsearch => {:prefix => true}
  }

  # == Instance methods == #
  def self.name_or_email_search(name, email)
    name_relation = name_search(name).pluck(:id)
    email_relation = email_search(email).pluck(:id)
    search_result = name_relation | email_relation
    return where('id IN (?)', search_result)
  end

  def self.import(import_params, current_org_id)
      error_messages = []
      contacts = []
    begin 
      spreadsheet, current_org = get_spreadsheet_and_organization(import_params, current_org_id)
      (1..spreadsheet.last_row).each do |index|
        contact = new
        contact.attributes = Hash[Contact::IMPORT_PARAMETERS.each_with_index.collect{ |item,i| [item, spreadsheet.cell(index,i+1)] }]
            .merge(organization_id: current_org_id,business_unit_id: import_params[:business_unit_id], contact_category_id:
            import_params[:contact_category_id])
        contact.handle_string_data_type
        contacts << contact
        contact.add_errors(index, error_messages)
      end
      contacts.map(&:save) if error_messages.blank?
    rescue Exception => e
      error_messages << e
    end
    error_messages 
  end

  # == Private == #
  def add_contact_to_project
    project_contacts.create!(project_id: project_id)
  end

  def has_project_id?
    project_id.present?    
  end

  def add_contact_to_company
    company_contacts.create!(company_id: company_id)
  end

  def has_company_id?
    company_id.present?    
  end

  def handle_string_data_type
    self.phone_number_1 = self.phone_number_1.to_i.to_s
    self.phone_number_2 = self.phone_number_2.to_i.to_s
    self.cell_phone = self.cell_phone.to_i.to_s    
  end

  def linkedin_url_validator
    return if linkedin_url.blank?

    unless linkedin_url.include? 'linkedin.com'
      errors.add(:linkedin_url, 'is incorrect')
    end
  end

  def strip_linkedin_url
    linkedin_url.gsub!(/^https?\:\/\/(www.)?|(www.)/,'') unless linkedin_url.blank?
  end
end
