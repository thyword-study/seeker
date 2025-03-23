# ## Schema Information
#
# Table name: `segment_verse_associations`
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
# * `index_segment_verse_associations_on_segment_id`:
#     * **`segment_id`**
# * `index_segment_verse_associations_on_verse_id`:
#     * **`verse_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`segment_id => segments.id`**
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`verse_id => verses.id`**
#
class SegmentVerseAssociation < ApplicationRecord
  # Associations
  belongs_to :segment
  belongs_to :verse

  # Validations
  validates :segment_id, presence: true
  validates :verse_id, presence: true
end
