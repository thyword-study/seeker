# ## Schema Information
#
# Table name: `exposition_system_prompts`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`content`**     | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
class Exposition::SystemPrompt < ApplicationRecord
  # Associations
  has_many :exposition_user_prompts, dependent: :restrict_with_error

  # Validations
  validates :content, presence: true
end
