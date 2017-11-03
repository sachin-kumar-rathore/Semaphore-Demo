class Project < ApplicationRecord

  include DateParser

  attr_accessor :active_date_str, :successful_completion_date_str, :site_visit_1_str,
                :site_visit_2_str, :site_visit_3_str, :public_release_date_str
  # CALLBACK
  before_validation :convert_dates_format

  # ASSOCIATION
  belongs_to :organization
  has_many :project_contacts, dependent: :destroy
  has_many :contacts, through: :project_contacts
  has_many :notes
  belongs_to :company, optional: true   #remove_optional_later

  # SCOPE
  scope :status, -> (status) { where("status IN (?)", status.values) }
  scope :primary_contact_id, -> (primary_contact_id) { where("primary_contact_id = (?)", primary_contact_id) }
  scope :unique_id, -> (unique_id) { where("unique_id = ?",unique_id)}
  scope :industry_type, -> (industry_type) { where("industry_type = ?",industry_type)}
  scope :start_date, -> (start_date) { where(active_date: (Date.strptime(start_date[:start], '%m/%d/%Y')..Date.strptime(start_date[:end], '%m/%d/%Y'))) if (start_date[:start].present? && start_date[:end].present?)}
  scope :completion, -> (completion) { where(successful_completion_date: (Date.strptime(completion[:start], '%m/%d/%Y')..Date.strptime(completion[:end], '%m/%d/%Y'))) if (completion[:start].present? && completion[:end].present?)}
  scope :project_name, -> (project_name) { where("name ilike ?","%#{name}%")}
  scope :public_release, -> (public_release) { where("public_release = ?",public_release)}
  scope :business_type, -> (business_type) { where("business_type IN (?)", business_type.values)}
  scope :site_visit, -> (site_visit) {  where("site_visit_1 BETWEEN :start AND :end 
                                          OR site_visit_2 BETWEEN :start AND :end
                                          OR site_visit_3 BETWEEN :start AND :end",
                                          start: site_visit[:start], end: site_visit[:end]  
                                        ) if site_visit[:start].present? && site_visit[:end].present?
                                      }
                                      
  # VALIDATION
  validates :unique_id, uniqueness: true, presence: true, length: { is: 6 }
  validates :name , presence: true


  #Add validation for project manager and company
  def convert_dates_format
    self.active_date = convert_date(active_date_str) if active_date_str.present? rescue nil
    self.successful_completion_date = convert_date(successful_completion_date_str) if successful_completion_date_str.present? rescue nil
    self.site_visit_1 = convert_date(site_visit_1_str) if site_visit_1_str.present? rescue nil
    self.site_visit_2 = convert_date(site_visit_2_str) if site_visit_2_str.present? rescue nil
    self.site_visit_3 = convert_date(site_visit_3_str) if site_visit_3_str.present? rescue nil
    self.public_release_date = convert_date(public_release_date_str) if public_release_date_str.present? rescue nil
  end

end
