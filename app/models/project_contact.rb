class ProjectContact < ApplicationRecord
  
  belongs_to :project
  belongs_to :contact
  audited associated_with: :project
end
