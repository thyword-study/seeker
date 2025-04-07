class AddExpositionBatchRequestToExpositionUserPrompts < ActiveRecord::Migration[8.0]
  def change
    add_reference :exposition_user_prompts, :batch_request, null: false, foreign_key: { on_delete: :restrict, to_table: :exposition_batch_requests }
  end
end
