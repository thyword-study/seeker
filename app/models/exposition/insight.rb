# ## Schema Information
#
# Table name: `exposition_insights`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`kind`**                   | `string`           | `not null`
# **`note`**                   | `text`             | `not null`
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`exposition_content_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_exposition_insights_on_exposition_content_id`:
#     * **`exposition_content_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`exposition_content_id => exposition_contents.id`**
#
class Exposition::Insight < ApplicationRecord
  # Associations
  belongs_to :exposition_content

  # Validations
  validates :exposition_content, presence: true
  validates :kind, presence: true
  validates :note, presence: true

  # Enums
  enum :kind, { christ_centered: "christ_centered" }
end
