# ## Schema Information
#
# Table name: `bible_segment_verse_associations`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`segment_id`**  | `bigint`           | `not null`
# **`verse_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_bible_segment_verse_associations_on_segment_id`:
#     * **`segment_id`**
# * `index_bible_segment_verse_associations_on_verse_id`:
#     * **`verse_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`segment_id => bible_segments.id`**
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`verse_id => bible_verses.id`**
#
class Bible::SegmentVerseAssociation < ApplicationRecord
  # Associations
  belongs_to :segment
  belongs_to :verse

  # Validations
  validates :segment, presence: true
  validates :verse, presence: true
end
