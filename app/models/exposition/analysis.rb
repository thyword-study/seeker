# ## Schema Information
#
# Table name: `exposition_analyses`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`note`**        | `text`             | `not null`
# **`part`**        | `string`           | `not null`
# **`position`**    | `integer`          | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`content_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_exposition_analyses_on_content_id`:
#     * **`content_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`content_id => exposition_contents.id`**
#
class Exposition::Analysis < ApplicationRecord
  # Associations
  belongs_to :content

  # Validations
  validates :content, presence: true
  validates :note, presence: true
  validates :part, presence: true
  validates :position, presence: true
end
