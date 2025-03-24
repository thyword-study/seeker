class Section < ApplicationRecord
  # Associations
  belongs_to :bible
  belongs_to :book
  belongs_to :chapter
  belongs_to :heading

  # Validations
  validates :bible, presence: true
  validates :book, presence: true
  validates :chapter, presence: true
  validates :heading, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
