# ## Schema Information
#
# Table name: `exposition_batch_requests`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`cancelled_at`**               | `datetime`         |
# **`cancelling_at`**              | `datetime`         |
# **`completed_at`**               | `datetime`         |
# **`data`**                       | `json`             |
# **`expired_at`**                 | `datetime`         |
# **`expires_at`**                 | `datetime`         |
# **`failed_at`**                  | `datetime`         |
# **`finalizing_at`**              | `datetime`         |
# **`in_progress_at`**             | `datetime`         |
# **`input_file_uploaded_at`**     | `datetime`         |
# **`name`**                       | `string`           | `not null`
# **`requested_completed_count`**  | `integer`          |
# **`requested_failed_count`**     | `integer`          |
# **`requested_total_count`**      | `integer`          |
# **`status`**                     | `string`           | `default("requested"), not null`
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`batch_id`**                   | `string`           |
# **`error_file_id`**              | `string`           |
# **`input_file_id`**              | `string`           |
# **`output_file_id`**             | `string`           |
#
class Exposition::BatchRequest < ApplicationRecord
  # Associations
  has_many :user_prompts, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true
  validates :status, presence: true
end
