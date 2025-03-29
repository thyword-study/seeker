# ## Schema Information
#
# Table name: `exposition_personal_applications`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`note`**                   | `string`           | `not null`
# **`title`**                  | `string`           | `not null`
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`exposition_content_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `idx_on_exposition_content_id_b900e2aa68`:
#     * **`exposition_content_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => cascade_):
#     * **`exposition_content_id => exposition_contents.id`**
#
class Exposition::PersonalApplication < ApplicationRecord
  # Associations
  belongs_to :exposition_content

  # Validations
  validates :exposition_content, presence: true
  validates :note, presence: true
  validates :title, presence: true
end
