class SectionGuide < ApplicationRecord
  validates_presence_of :section_name, :section_info
end
