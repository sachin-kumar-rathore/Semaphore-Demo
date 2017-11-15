class Organization < ApplicationRecord

  has_many :users

  has_many :contacts, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :projects
  has_many :tasks, through: :users
  has_many :emails, dependent: :destroy
  has_many :documents, dependent: :destroy

  validates_presence_of :name, :primary_contact_first_name, :primary_contact_phone, :primary_contact_email
  validates_format_of :primary_contact_email, with: Devise::email_regexp

end
