class ProjectContact < ApplicationRecord
  
  belongs_to :project
  belongs_to :contact
  audited associated_with: :project

  # === Callbacks === #
  after_create_commit :assign_contact_emails_to_project, if: :contact_emails_present?
  after_destroy_commit :remove_contact_emails_from_project, if: :contact_emails_present?

  # === Private Methods === #
  private

  def assign_contact_emails_to_project
    ProjectEmailWorker.perform_in(1.minutes, 'assign', self.contact.id, self.project.id)
  end

  def remove_contact_emails_from_project
    ProjectEmailWorker.perform_in(1.minutes, 'remove', self.contact.id, self.project.id)
  end

  def contact_emails_present?
    self.contact.emails.count > 0
  end
end
