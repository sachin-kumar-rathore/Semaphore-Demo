class Organization < ApplicationRecord

  has_many :users
  has_many :contacts, :dependent => :destroy
  
end
