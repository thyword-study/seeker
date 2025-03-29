# ## Schema Information
#
# Table name: `exposition_cross_references`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`note`**                   | `string`           | `not null`
# **`reference`**              | `string`           | `not null`
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`exposition_content_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_exposition_cross_references_on_exposition_content_id`:
#     * **`exposition_content_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`exposition_content_id => exposition_contents.id`**
#
class Exposition::CrossReference < ApplicationRecord
  # Associations
  belongs_to :exposition_content

  # Validations
  validates :exposition_content, presence: true
  validates :note, presence: true
  validates :reference, presence: true
end
