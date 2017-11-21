class Organization < ApplicationRecord

  BUSINESS_UNITS = ['Default', 'Cell', 'Work', 'Office', 'Home', 'Other']
  PROJECT_TYPES = ['Bio-Medical', 'Call Center', 'Data Center', 'Information Technology', 'Manufacturing', 'Warehouse']
  INDUSTRY_TYPES = ['Advanced Manufacturing', 'Aerospace', 'Ag Service', 'Bioscience', 'Energy', 'Financial', 'Food Processing', 'Insurance', 'Logistics/Material Handling', 'Military', 'Retail']

  has_many :users

  has_many :contacts, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :projects
  has_many :tasks, through: :users
  has_many :emails, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :companies, dependent: :destroy

  validates_presence_of :name, :primary_contact_first_name, :primary_contact_phone, :primary_contact_email
  validates_format_of :primary_contact_email, with: Devise::email_regexp

end
