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

  def add_role(role, organization)
    security_role = organization.security_roles.where(name: role).first
    self.user_roles.create!(security_role_id: security_role.id)
  end

  validates_presence_of :first_name, :last_name
  validate :minimum_one_role

  private

  def minimum_one_role
    if self.user_roles.blank?
      errors.add(:base, 'User must be assigned atleast one role.')
    end
  end
end
