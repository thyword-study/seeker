# ## Schema Information
#
# Table name: `exposition_user_prompts`
#
# ### Columns
#
# Name                               | Type               | Attributes
# ---------------------------------- | ------------------ | ---------------------------
# **`id`**                           | `bigint`           | `not null, primary key`
# **`content`**                      | `text`             | `not null`
# **`created_at`**                   | `datetime`         | `not null`
# **`updated_at`**                   | `datetime`         | `not null`
# **`exposition_system_prompt_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_exposition_user_prompts_on_exposition_system_prompt_id`:
#     * **`exposition_system_prompt_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`exposition_system_prompt_id => exposition_system_prompts.id`**
#
class Exposition::UserPrompt < ApplicationRecord
  # Associations
  belongs_to :exposition_system_prompt
  has_one :exposition_content, dependent: :restrict_with_error

  # Validations
  validates :content, presence: true
  validates :exposition_system_prompt, presence: true
end
