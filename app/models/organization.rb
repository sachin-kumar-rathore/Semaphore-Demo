class Organization < ApplicationRecord

  SETTINGS = ['project_types', 'industry_types', 'provided_services', 'competitions', 
              'sources', 'elimination_reasons', 'contact_categories', 'business_units',
              'contact_method_types', 'company_activity_types']

  has_many :users

  has_many :contacts, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :projects
  has_many :tasks, through: :users
  has_many :emails, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :companies, dependent: :destroy
  has_many :project_types, dependent: :destroy
  has_many :industry_types, dependent: :destroy
  has_many :provided_services, dependent: :destroy
  has_many :competitions, dependent: :destroy
  has_many :sources, dependent: :destroy
  has_many :contact_categories, dependent: :destroy
  has_many :elimination_reasons, dependent: :destroy
  has_many :business_units, dependent: :destroy
  has_many :contact_method_types, dependent: :destroy
  has_many :company_activity_types, dependent: :destroy
  has_many :considered_locations, dependent: :destroy
    
  validates_presence_of :name, :primary_contact_first_name, :primary_contact_phone, :primary_contact_email
  validates_format_of :primary_contact_email, with: Devise::email_regexp

end
