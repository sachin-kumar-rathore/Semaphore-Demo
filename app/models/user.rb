class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :organization, optional: true
  has_many :tasks, dependent: :destroy
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assignee_id
  has_many :documents

  def full_name
    "#{first_name} #{last_name}"
  end

  validates_presence_of :first_name, :last_name
  
end
