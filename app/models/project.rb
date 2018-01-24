require 'searchable'
# Project Model
class Project < ApplicationRecord
  include DateParser
  include Searchable

  SQUARE_FEET_REQUESTED = ['1-25,999', '26-44,999', '45-75,999',
                           '76-99,999', '100-149,999', '150-199,999',
                           '200-399,999', '400,000+'].freeze
  ACRES_REQUESTED = ['up to 1', 'up to 2', 'up to 3', 'up to 4',
                     'up to 5'].freeze
  BUSINESS_TYPE = ['Existing Business', 'New Business'].freeze
  STATUS = %w[Preliminary Active Delayed Eliminated Successful
              Inactive].freeze

  attr_accessor :active_date_str, :successful_completion_date_str,
                :site_visit_1_str, :site_visit_2_str, :site_visit_3_str,
                :public_release_date_str, :activity_id
  # CALLBACK
  before_validation :convert_dates_format
  after_create :copy_activity_records, if: :has_activity_id?

  # ASSOCIATION
  belongs_to :organization
  has_many :project_contacts, dependent: :destroy
  has_many :contacts, through: :project_contacts
  has_many :project_sites, dependent: :destroy
  has_many :sites, through: :project_sites
  has_many :notes, as: :notable, dependent: :destroy
  belongs_to :company, optional: true
  has_many :tasks, as: :taskable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :emails, as: :mailable, dependent: :destroy
  belongs_to :project_type
  belongs_to :industry_type
  belongs_to :business_unit
  belongs_to :considered_location
  belongs_to :competition
  belongs_to :provided_service
  belongs_to :source
  belongs_to :elimination_reason

  # SCOPE
  scope :status, ->(status) { where('status IN (?)', status.values) }
  scope :primary_contact_id, ->(primary_contact_id) { where('primary_contact_id = (?)', primary_contact_id) }
  scope :project_number, ->(project_number) { where('project_number = ?', project_number) }
  scope :industry_type_id, ->(industry_type_id) { where('industry_type_id = ?', industry_type_id) }
  scope :start_date, ->(start_date) { where(active_date: (Date.strptime(start_date[:start], '%m/%d/%Y')..Date.strptime(start_date[:end], '%m/%d/%Y'))) if start_date[:start].present? && start_date[:end].present? }
  scope :completion, ->(completion) { where(successful_completion_date: (Date.strptime(completion[:start], '%m/%d/%Y')..Date.strptime(completion[:end], '%m/%d/%Y'))) if completion[:start].present? && completion[:end].present? }
  scope :project_name, ->(project_name) { where('name ilike ?', "%#{project_name}%") }
  scope :public_release, ->(public_release) { where('public_release = ?', public_release) }
  scope :business_type, ->(business_type) { where('business_type IN (?)', business_type.values) }
  scope :site_visit, ->(site_visit) {
                       if site_visit[:start].present? && site_visit[:end].present?
                         where("site_visit_1 BETWEEN :start AND :end
                                            OR site_visit_2 BETWEEN :start AND :end
                                            OR site_visit_3 BETWEEN :start AND :end",
                               start: site_visit[:start], end: site_visit[:end])
                       end
                     }
  scope :considered_location_id, ->(considered_location_id) { where('considered_location_id = ?', considered_location_id) }
  scope :project_type_id, ->(project_type_id) { where('project_type_id = ?', project_type_id) }
  scope :source_id, ->(source_id) { where('source_id = ?', source_id) }
  scope :company, ->(company) { where('company_id = ?', company) }
  scope :filter_by_active_date, -> (start_time, end_time) { where("active_date >= ? AND active_date <= ?", start_time, end_time)}

  # VALIDATION
  validates :project_number, uniqueness: true, presence: true, length: { is: 6 }
  validates :name, presence: true
  validate :successful_completion_date_is_after_active_date
  validates :business_type, inclusion: { in: Project::BUSINESS_TYPE, message: '%{value} is not a valid business type.' }
  validates :status, inclusion: { in: Project::STATUS, message: '%{value} is not a valid status for a project.' }
  validates :business_type, inclusion: { in: Project::BUSINESS_TYPE, message: '%{value} is not a valid business type.' }
  validates :square_feet_requested, inclusion: { in: Project::SQUARE_FEET_REQUESTED, message: '%{value} is not valid.' }
  validates :acres_requested, inclusion: { in: Project::ACRES_REQUESTED, message: '%{value} is not valid.' }

  #Add validation for project manager and company
  private

  def convert_dates_format
    begin
      self.active_date = convert_date(active_date_str) if active_date_str.present?
    rescue StandardError
      nil
    end
    begin
      self.successful_completion_date = convert_date(successful_completion_date_str) if successful_completion_date_str.present?
    rescue StandardError
      nil
    end
    begin
      self.site_visit_1 = convert_date(site_visit_1_str) if site_visit_1_str.present?
    rescue StandardError
      nil
    end
    begin
      self.site_visit_2 = convert_date(site_visit_2_str) if site_visit_2_str.present?
    rescue StandardError
      nil
    end
    begin
      self.site_visit_3 = convert_date(site_visit_3_str) if site_visit_3_str.present?
    rescue StandardError
      nil
    end
    begin
      self.public_release_date = convert_date(public_release_date_str) if public_release_date_str.present?
    rescue StandardError
      nil
    end
  end

  def successful_completion_date_is_after_active_date
    return if successful_completion_date.blank? || active_date.blank?

    if successful_completion_date < active_date
      errors.add(:successful_completion_date, 'cannot be before the start date')
    end
  end

  def has_activity_id?
    activity_id.present?
  end

  def copy_activity_records
    current_org = organization
    @activity = current_org.activities.where(id: activity_id).first
    @activity.notes.each do |note|
      notes.new(note.dup.attributes.merge(notable_type: 'Project'))
    end
    @activity.emails.each do |email|
      emails.new(email.dup.attributes.merge(mailable_type: 'Project'))
    end
    @activity.tasks.each do |task|
      tasks.new(task.dup.attributes.merge(taskable_type: 'Project'))
    end
    @activity.documents.each do |document|
      documents.new(document.dup.attributes.merge(documentable_type: 'Project', name: document.name))
    end
    save
    @activity.update_attribute(:converted, true)
  end
end
