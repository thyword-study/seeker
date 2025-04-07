# ## Schema Information
#
# Table name: `exposition_user_prompts`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`text`**              | `text`             | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`section_id`**        | `bigint`           | `not null`
# **`system_prompt_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_exposition_user_prompts_on_section_id`:
#     * **`section_id`**
# * `index_exposition_user_prompts_on_system_prompt_id`:
#     * **`system_prompt_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`section_id => sections.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`system_prompt_id => exposition_system_prompts.id`**
#
class Exposition::UserPrompt < ApplicationRecord
  # Associations
  belongs_to :section
  belongs_to :system_prompt
  has_one :content, dependent: :restrict_with_error

  # Validations
  validates :section, presence: true
  validates :system_prompt, presence: true
  validates :text, presence: true
end
