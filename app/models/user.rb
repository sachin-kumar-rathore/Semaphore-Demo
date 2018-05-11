# Model for user in organization
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :authy_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable
         
  belongs_to :organization, optional: true
  has_many :tasks, dependent: :destroy
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assignee_id
  has_many :documents, dependent: :nullify
  has_many :user_roles, dependent: :destroy
  has_many :security_roles, through: :user_roles
  has_many :custom_exports, dependent: :destroy
  has_many :temp_contacts, dependent: :destroy
  has_many :suspicious_activities

  before_save :minimum_one_role
  after_update :welcome_user_and_notify_admin, if: :saved_change_to_invitation_accepted_at?

  PAGINATION_VALUE = 8
  
  scope :all_except, ->(user) { where.not(id: user) }
  scope :first_name, ->(first_name) { where('first_name ilike ?', "%#{first_name}%") }
  scope :last_name, ->(last_name) { where('last_name ilike ?', "%#{last_name}%") }
  scope :user_role, -> (user_role) { where(user_roles: {security_role_id: user_role})}

  validates_presence_of :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end

  def status
    active ? 'Active' : 'Inactive'
  end

  def invitation_status
    if invitation_sent_at?
      invitation_accepted? ? 'Accepted' : 'Pending'
    else
      'Not Invited'
    end
  end

  def can_write?(module_controller)
    accesses = module_accesses(module_controller)
    return false unless accesses.present?
    accesses.map { |permissions| eval(permissions)['access'] }.uniq.include?('Write')
  end

  def can_access_module?(module_controller)
    # Uncomment below code when 'status' column of /security_roles form is enabled
    #accesses = module_accesses(module_controller)
    #return true unless accesses.present?
    #accesses.map { |permissions| eval(permissions)['status'] }.uniq.include?('true')
    return true
  end

  protected

  def send_devise_notification(notification, *args)
    case notification
    when :reset_password_instructions
      trigger_email(3, self.id, { token: args[0] })
    when :invitation_instructions
      send_emails_to_users(8, 9, 12, { token: args[0] })
    end
  end

  private

  def minimum_one_role
    if user_roles.blank? && created_by_invite?
      errors.add(:base, 'User must be assigned atleast one role.')
    end
  end

  def welcome_user_and_notify_admin
    send_emails_to_users(10, 11, 13)
  end

  def send_emails_to_users(emailTypeId, admin_emailTypeId, invited_by_emailTypeID, opts={})
    trigger_email(emailTypeId, self.id, opts)
    notify_admins(admin_emailTypeId)
    notify_invited_by_user(invited_by_emailTypeID) if invited_by
  end

  def notify_admins(emailTypeId)
    admin_users = organization.administrators.reject { |admin_user| admin_user.invitation_status == 'Pending'} 
    admin_users.uniq.each do |admin_user|
      trigger_email(emailTypeId, admin_user.id, { new_user_id: self.id })
    end
  end

  def notify_invited_by_user(emailTypeId)
    trigger_email(emailTypeId, self.invited_by.id, { new_user_id: self.id })
  end

  def trigger_email(type_id, user_id, opts={})
    TransactionEmailWorker.perform_async(type_id, 'user', user_id, opts)
  end

  def module_accesses(module_controller)
    security_roles.map { |role| role.accesses[module_controller]  }
                  .reject { |access| access.nil? }
  end

  def check_permissions(module_controller, key, value)
    accesses = module_accesses(module_controller)
    return false unless accesses.present?
    accesses.map { |permissions| eval(permissions)[key] }.uniq.include?(value)
  end
end
