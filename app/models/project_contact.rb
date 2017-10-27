class ProjectContact < ApplicationRecord
  
  belongs_to :project
  belongs_to :contact
  
end
