class Site < ApplicationRecord

  # == Constants == #
  self.per_page = 5

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #
  include PgSearch

  # == Associations and Nested Attributes == #
  belongs_to :organization

  # == Validations == #
  validates_presence_of :organization_id, :property_name, :property_number, :property_type, :address_line, :city, :state,
                        :zip_code, :country, :available_acreage, :available_square_feet, :total_acreage,
                        :total_square_feet, :latitude, :longitude

  # == Callbacks == #

  # == Scopes and Other macros == #
  pg_search_scope :property_name_search, :against => :propoerty_name
  pg_search_scope :property_number_search, :against => :property_number
  pg_search_scope :zip_code_search, :against => :zip_code

  # == Instance methods == #
  def self.property_number_or_propery_name_or_zip_code_search(org_id, number, name, zip_code)
    number_relation = property_number_search(number).pluck(:id)
    name_relation = property_number_search(name).pluck(:id)
    zip_code_relation = zip_code_search(zip_code).pluck(:id)
    search_result = number_relation | name_relation | zip_code_relation
    return where('id IN (?) AND organization_id = ?', search_result, org_id)
  end

  # == Private == #
end
