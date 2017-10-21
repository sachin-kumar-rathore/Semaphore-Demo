class Task < ApplicationRecord

  # == Constants == #
  STATUS = ['In-Progress', 'Complete']
  PRIORITY = ['High', 'Medium', 'Low']

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #

  # == Associations and Nested Attributes == #
  belongs_to :user
  # belongs_to :project

  # == Validations == #
  validates_presence_of :name, :assigned_to

  # == Callbacks == #

  # == Scopes and Other macros == #

  # == Instance methods == #

  # == Private == #


end
