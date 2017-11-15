class Site < ApplicationRecord

  acts_as_paranoid

  # == Constants == #
  self.per_page = 5

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #

  # == Associations and Nested Attributes == #
  belongs_to :organization

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

  # == Scopes and Other macros == #
  scope :property_name, -> (property_name) { where("property_name ilike ?","%#{property_name}%")}
  scope :property_number, -> (property_number) { where("property_number = ?",property_number)}
  scope :zip_code, -> (zip_code) { where("zip_code = ?",zip_code)}
  # == Instance methods == #

  # == Private == #
end
