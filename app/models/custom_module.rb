class CustomModule < ApplicationRecord
  validates_presence_of :name, :controller_name
end
