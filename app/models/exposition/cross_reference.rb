# ## Schema Information
#
# Table name: `exposition_cross_references`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`note`**        | `text`             | `not null`
# **`reference`**   | `string`           | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`content_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_exposition_cross_references_on_content_id`:
#     * **`content_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`content_id => exposition_contents.id`**
#
class Exposition::CrossReference < ApplicationRecord
  # Associations
  belongs_to :content

  # Validations
  validates :content, presence: true
  validates :note, presence: true
  validates :reference, presence: true
end
