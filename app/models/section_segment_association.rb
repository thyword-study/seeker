# ## Schema Information
#
# Table name: `section_segment_associations`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`section_id`**  | `bigint`           | `not null`
# **`segment_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_section_segment_associations_on_section_id`:
#     * **`section_id`**
# * `index_section_segment_associations_on_segment_id`:
#     * **`segment_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`section_id => sections.id`**
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`segment_id => segments.id`**
#
class SectionSegmentAssociation < ApplicationRecord
  # Associations
  belongs_to :section
  belongs_to :segment

  # Validations
  validates :section, presence: true
  validates :segment, presence: true
end
