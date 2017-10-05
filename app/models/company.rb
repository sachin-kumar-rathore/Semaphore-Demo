class Company < ApplicationRecord
  # == Constants == #

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #

  # == Associations and Nested Attributes == #

  # == Validations == #
  validates_presence_of :owner_id, :subscription_id, :name, :email

  # == Callbacks == #

  # == Scopes and Other macros == #

  # == Instance methods == #

  # == Private == #
end
