class Task < ApplicationRecord

  # == Constants == #
  STATUS = ['In-Progress', 'Complete']
  PRIORITY = ['High', 'Medium', 'Low']

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #

  # == Associations and Nested Attributes == #
  belongs_to :user
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
  # belongs_to :project

  # == Validations == #
  validates_presence_of :name, :assignee_id

  # == Callbacks == #

  # == Scopes and Other macros == #
  scope :get_current_org_tasks, lambda { |org_id| joins(:user).where( users: {organization_id: org_id}) }
  # == Instance methods == #

  # == Private == #


end
