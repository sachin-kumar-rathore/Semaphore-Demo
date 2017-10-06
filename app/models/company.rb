class Company < ApplicationRecord
  # == Constants == #

  # == Attributes == #

  # == File Uploader == #

  # == Modules == #

  # == Associations and Nested Attributes == #

  # == Validations == #
  validates_presence_of :owner_id, :subscription_id, :name
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  # == Callbacks == #

  # == Scopes and Other macros == #

  # == Instance methods == #

  # == Private == #
end
