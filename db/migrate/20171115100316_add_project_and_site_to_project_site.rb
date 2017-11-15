class AddProjectAndSiteToProjectSite < ActiveRecord::Migration[5.1]
  def change
    add_reference :project_sites, :project, foreign_key: true
    add_reference :project_sites, :site, foreign_key: true
  end
end
