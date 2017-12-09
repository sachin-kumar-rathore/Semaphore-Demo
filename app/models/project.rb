class Project < ApplicationRecord

  include DateParser

  SQUARE_FEET_REQUESTED = ['1-25,999', '26-44,999', '45-75,999', '76-99,999', '100-149,999', '150-199,999', '200-399,999', '400,000+']
  ACRES_REQUESTED = ['up to 1', 'up to 2', 'up to 3', 'up to 4', 'up to 5']
  BUSINESS_TYPE = ['Existing Business', 'New Business']
  STATUS = ['Preliminary', 'Active', 'Delayed', 'Eliminated', 'Successful', 'Inactive']
  
  attr_accessor :active_date_str, :successful_completion_date_str, :site_visit_1_str,
                :site_visit_2_str, :site_visit_3_str, :public_release_date_str
  # CALLBACK
  before_validation :convert_dates_format

  # ASSOCIATION
  belongs_to :organization
  has_many :project_contacts, dependent: :destroy
  has_many :contacts, through: :project_contacts
  has_many :project_sites, dependent: :destroy
  has_many :sites, through: :project_sites
  has_many :notes, dependent: :destroy
  belongs_to :company, dependent: :destroy
  has_many :tasks, dependent: :nullify
  has_many :emails, dependent: :nullify
  has_many :documents, dependent: :nullify
  belongs_to :project_type
  belongs_to :industry_type
  belongs_to :business_unit
  belongs_to :considered_location
  belongs_to :competition
  belongs_to :provided_service
  belongs_to :source
  belongs_to :elimination_reason

  # SCOPE
  scope :status, -> (status) { where("status IN (?)", status.values) }
  scope :primary_contact_id, -> (primary_contact_id) { where("primary_contact_id = (?)", primary_contact_id) }
  scope :project_number, -> (project_number) { where("project_number = ?",project_number)}
  scope :industry_type_id, -> (industry_type_id) { where("industry_type_id = ?",industry_type_id)}
  scope :start_date, -> (start_date) { where(active_date: (Date.strptime(start_date[:start], '%m/%d/%Y')..Date.strptime(start_date[:end], '%m/%d/%Y'))) if (start_date[:start].present? && start_date[:end].present?)}
  scope :completion, -> (completion) { where(successful_completion_date: (Date.strptime(completion[:start], '%m/%d/%Y')..Date.strptime(completion[:end], '%m/%d/%Y'))) if (completion[:start].present? && completion[:end].present?)}
  scope :project_name, -> (project_name) { where("name ilike ?","%#{project_name}%")}
  scope :public_release, -> (public_release) { where("public_release = ?",public_release)}
  scope :business_type, -> (business_type) { where("business_type IN (?)", business_type.values)}
  scope :site_visit, -> (site_visit) {  where("site_visit_1 BETWEEN :start AND :end 
                                          OR site_visit_2 BETWEEN :start AND :end
                                          OR site_visit_3 BETWEEN :start AND :end",
                                          start: site_visit[:start], end: site_visit[:end]  
                                        ) if site_visit[:start].present? && site_visit[:end].present?
                                      }
  scope :considered_location_id, -> (considered_location_id) { where("considered_location_id = ?",considered_location_id)}
  scope :project_type_id, -> (project_type_id) { where("project_type_id = ?",project_type_id)}
  scope :source_id, -> (source_id) { where("source_id = ?",source_id)}
  scope :company_id, -> (company_id) { where("company_id = ?",company_id)}
  scope :filter_by_creation, -> (start_time, end_time) { where("created_at >= ? AND created_at <= ?", start_time, end_time)}

  # VALIDATION
  validates :project_number, uniqueness: true, presence: true, length: { is: 6 }
  validates :name , presence: true
  validate  :successful_completion_date_is_after_active_date
  validates :business_type, inclusion: { in: Project::BUSINESS_TYPE, message: "%{value} is not a valid business type." }
  validates :status, inclusion: { in: Project::STATUS, message: "%{value} is not a valid status for a project." }
  validates :business_type, inclusion: { in: Project::BUSINESS_TYPE, message: "%{value} is not a valid business type." }
  validates :square_feet_requested, inclusion: { in: Project::SQUARE_FEET_REQUESTED, message: "%{value} is not valid." }
  validates :acres_requested, inclusion: { in: Project::ACRES_REQUESTED, message: "%{value} is not valid." }

  #Add validation for project manager and company
  private

  def convert_dates_format
    self.active_date = convert_date(active_date_str) if active_date_str.present? rescue nil
    self.successful_completion_date = convert_date(successful_completion_date_str) if successful_completion_date_str.present? rescue nil
    self.site_visit_1 = convert_date(site_visit_1_str) if site_visit_1_str.present? rescue nil
    self.site_visit_2 = convert_date(site_visit_2_str) if site_visit_2_str.present? rescue nil
    self.site_visit_3 = convert_date(site_visit_3_str) if site_visit_3_str.present? rescue nil
    self.public_release_date = convert_date(public_release_date_str) if public_release_date_str.present? rescue nil
  end

  def successful_completion_date_is_after_active_date
    return if successful_completion_date.blank? || active_date.blank?

    if successful_completion_date < active_date
      errors.add(:successful_completion_date, "cannot be before the start date") 
    end 
  end

end
