class Site < ApplicationRecord

  acts_as_paranoid
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
  # == Validations == #
  validates_presence_of :organization_id, :contact_id, :property_name, :property_number, :property_type, :address_line, :city, :state,
                        :zip_code, :country

  validates :available_acreage, presence:true, numericality: {only_float: true}
  validates :available_square_feet, presence:true, numericality: {only_float: true}
  validates :total_acreage, presence:true, numericality: {only_float: true}
  validates :total_square_feet, presence:true, numericality: {only_float: true}
  validates :latitude, presence:true, numericality: {only_float: true}
  validates :longitude, presence:true, numericality: {only_float: true}


  # == Callbacks == #
  after_create :add_site_to_project, if: :has_project_id?
  # == Scopes and Other macros == #
  scope :property_name, -> (property_name) { where("property_name ilike ?","%#{property_name}%")}
  scope :property_number, -> (property_number) { where("property_number = ?",property_number)}
  scope :zip_code, -> (zip_code) { where("zip_code = ?",zip_code)}
  # == Instance methods == #

  # == Private == #
  def add_site_to_project
    project_sites.create!(project_id: project_id)
  end

  def has_project_id?
    project_id.present?    
  end
  
end
