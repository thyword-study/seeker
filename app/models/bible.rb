# ## Schema Information
#
# Table name: `bibles`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `bigint`           | `not null, primary key`
# **`code`**                | `string(3)`        | `not null`
# **`name`**                | `string`           | `not null`
# **`rights_holder_name`**  | `string`           | `not null`
# **`rights_holder_url`**   | `string`           | `not null`
# **`statement`**           | `text`             | `not null`
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_bibles_on_code` (_unique_):
#     * **`code`**
#
class Bible < ApplicationRecord
  # Associations
  has_many :books, dependent: :restrict_with_exception
  has_many :chapters, dependent: :restrict_with_exception
  has_many :footnotes, dependent: :restrict_with_exception
  has_many :fragments, dependent: :restrict_with_exception
  has_many :headings, dependent: :restrict_with_exception
  has_many :references, dependent: :restrict_with_exception
  has_many :segments, dependent: :restrict_with_exception
  has_many :verses, dependent: :restrict_with_exception

  # Validations
  validates :code, presence: true, length: { is: 3 }, uniqueness: true
  validates :name, presence: true
  validates :rights_holder_name, presence: true
  validates :rights_holder_url, presence: true, url: true
  validates :statement, presence: true
end
