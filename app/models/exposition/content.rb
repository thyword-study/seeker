# ## Schema Information
#
# Table name: `exposition_contents`
#
# ### Columns
#
# Name                       | Type               | Attributes
# -------------------------- | ------------------ | ---------------------------
# **`id`**                   | `bigint`           | `not null, primary key`
# **`context`**              | `text`             | `not null`
# **`highlights`**           | `text`             | `default([]), not null, is an Array`
# **`interpretation_type`**  | `string`           | `not null`
# **`people`**               | `string`           | `default([]), not null, is an Array`
# **`places`**               | `string`           | `default([]), not null, is an Array`
# **`reflections`**          | `text`             | `default([]), not null, is an Array`
# **`summary`**              | `text`             | `not null`
# **`tags`**                 | `string`           | `default([]), not null, is an Array`
# **`created_at`**           | `datetime`         | `not null`
# **`updated_at`**           | `datetime`         | `not null`
# **`section_id`**           | `bigint`           | `not null`
# **`user_prompt_id`**       | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_exposition_contents_on_highlights` (_using_ gin):
#     * **`highlights`**
# * `index_exposition_contents_on_people` (_using_ gin):
#     * **`people`**
# * `index_exposition_contents_on_places` (_using_ gin):
#     * **`places`**
# * `index_exposition_contents_on_reflections` (_using_ gin):
#     * **`reflections`**
# * `index_exposition_contents_on_section_id`:
#     * **`section_id`**
# * `index_exposition_contents_on_tags` (_using_ gin):
#     * **`tags`**
# * `index_exposition_contents_on_user_prompt_id`:
#     * **`user_prompt_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`section_id => bible_sections.id`**
# * `fk_rails_...` (_ON DELETE => restrict_):
#     * **`user_prompt_id => exposition_user_prompts.id`**
#
class Exposition::Content < ApplicationRecord
  # Associations
  belongs_to :section
  belongs_to :user_prompt
  has_many :alternative_interpretations, dependent: :destroy
  has_many :analyses, dependent: :destroy
  has_many :cross_references, dependent: :destroy
  has_many :insights, dependent: :destroy
  has_many :key_themes, dependent: :destroy
  has_many :personal_applications, dependent: :destroy

  # Validations
  validates :context, presence: true
  validates :highlights, presence: true
  validates :interpretation_type, presence: true
  validates :reflections, presence: true
  validates :section, presence: true
  validates :summary, presence: true
  validates :tags, presence: true
  validates :user_prompt, presence: true

  # Enums
  enum :interpretation_type, { majority: "majority", minority:  "minority" }
end
