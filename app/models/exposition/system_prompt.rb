# ## Schema Information
#
# Table name: `exposition_system_prompts`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`text`**        | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
class Exposition::SystemPrompt < ApplicationRecord
  # Associations
  has_many :user_prompts, dependent: :restrict_with_error

  # Validations
  validates :text, presence: true
end
