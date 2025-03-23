class SegmentVerseAssociations < ApplicationRecord
  # Associations
  belongs_to :segment
  belongs_to :verse

  # Validations
  validates :segment_id, presence: true
  validates :verse_id, presence: true
end
