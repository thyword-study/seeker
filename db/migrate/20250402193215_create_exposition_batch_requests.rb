class CreateExpositionBatchRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_batch_requests do |t|
      t.string :name, null: false
      t.string :status, null: false, default: 'requested'
      t.json :data

      t.string :input_file_id
      t.string :batch_id
      t.string :error_file_id
      t.string :output_file_id

      t.datetime :input_file_uploaded_at
      t.datetime :in_progress_at
      t.datetime :cancelling_at
      t.datetime :expires_at
      t.datetime :finalizing_at
      t.datetime :completed_at
      t.datetime :failed_at
      t.datetime :cancelled_at
      t.datetime :expired_at

      t.integer :requested_total_count
      t.integer :requested_completed_count
      t.integer :requested_failed_count

      t.timestamps
    end
  end
end
