module Auditable
  
  def create_audit_record(user, project)
    audit = project.associated_audits.new()
    audit.auditable = self
    audit.user = user
    audit.action = 'update'
    audit.save
  end
end