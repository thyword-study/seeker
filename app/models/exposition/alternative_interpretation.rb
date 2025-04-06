# ## Schema Information
#
# Table name: `exposition_alternative_interpretations`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`note`**        | `text`             | `not null`
# **`title`**       | `string`           | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`content_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_exposition_alternative_interpretations_on_content_id`:
#     * **`content_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`content_id => exposition_contents.id`**
#
class Exposition::AlternativeInterpretation < ApplicationRecord
  # Associations
  belongs_to :exposition_content

  # Validations
  validates :exposition_content, presence: true
  validates :note, presence: true
  validates :title, presence: true
end
