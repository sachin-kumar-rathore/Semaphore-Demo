class Organization < ApplicationRecord

  has_many :users

  has_many :contacts, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :projects
  has_many :tasks, through: :users
end
