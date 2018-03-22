# Model for user in organization
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable
  belongs_to :organization, optional: true
  has_many :tasks, dependent: :destroy
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assignee_id
  has_many :documents, dependent: :nullify
  has_many :user_roles, dependent: :destroy
  has_many :security_roles, through: :user_roles
  has_many :custom_exports, dependent: :destroy
  before_save :minimum_one_role
  after_update :welcome_user_and_notify_admin, if: :saved_change_to_invitation_accepted_at?

  PAGINATION_VALUE = 8
  
  scope :all_except, ->(user) { where.not(id: user) }
  scope :first_name, ->(first_name) { where('first_name ilike ?', "%#{first_name}%") }
  scope :last_name, ->(last_name) { where('last_name ilike ?', "%#{last_name}%") }
  scope :user_role, -> (user_role) { where(user_roles: {security_role_id: user_role})}

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

  validates_presence_of :first_name, :last_name

  protected

  def send_devise_notification(notification, *args)
    case notification
    when :reset_password_instructions
      TransactionEmailWorker.perform_async(3, 'user', self.id, { token: args[0] })
    when :invitation_instructions
      send_invitation_emails(args[0])
    end
  end

  private

  def minimum_one_role
    if user_roles.blank? && created_by_invite?
      errors.add(:base, 'User must be assigned atleast one role.')
    end
  end

  def send_invitation_emails(token)
    TransactionEmailWorker.perform_async(8, 'user', self.id, { token: token })
    notify_admins(9)
  end

  def welcome_user_and_notify_admin
    TransactionEmailWorker.perform_async(10, 'user', self.id)
    notify_admins(11)
  end

  def notify_admins(emailTypeId)
    @admin_users = organization.administrators.reject { |admin_user| admin_user.id == self.id }
    @admin_users.each do |admin_user|
      TransactionEmailWorker.perform_async(emailTypeId, 'user', admin_user.id, { new_user_id: self.id })
    end
  end
end
