# ## Schema Information
#
# Table name: `exposition_key_themes`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`description`**            | `text`             | `not null`
# **`theme`**                  | `string`           | `not null`
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`exposition_content_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_exposition_key_themes_on_exposition_content_id`:
#     * **`exposition_content_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`exposition_content_id => exposition_contents.id`**
#
class Exposition::KeyTheme < ApplicationRecord
  # Associations
  belongs_to :exposition_content

  # Validations
  validates :description, presence: true
  validates :exposition_content, presence: true
  validates :theme, presence: true
end
