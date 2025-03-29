# ## Schema Information
#
# Table name: `exposition_analyses`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`note`**                   | `string`           | `not null`
# **`position`**               | `integer`          | `not null`
# **`section`**                | `string`           | `not null`
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`exposition_content_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_exposition_analyses_on_exposition_content_id`:
#     * **`exposition_content_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`exposition_content_id => exposition_contents.id`**
#
class Exposition::Analysis < ApplicationRecord
  # Associations
  belongs_to :exposition_content

  # Validations
  validates :exposition_content, presence: true
  validates :note, presence: true
  validates :position, presence: true
  validates :section, presence: true
end
