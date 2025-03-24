class SectionSegmentAssociation < ApplicationRecord
  # Associations
  belongs_to :section
  belongs_to :segment

  # Validations
  validates :section, presence: true
  validates :segment, presence: true
end
