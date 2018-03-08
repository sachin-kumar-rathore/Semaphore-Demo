class ProjectSite < ApplicationRecord

  belongs_to :project
  belongs_to :site
  audited associated_with: :project
end
