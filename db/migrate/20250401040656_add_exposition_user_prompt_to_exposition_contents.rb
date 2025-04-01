class AddExpositionUserPromptToExpositionContents < ActiveRecord::Migration[8.0]
  def change
    add_reference :exposition_contents, :exposition_user_prompt, null: false, foreign_key: { on_delete: :restrict }
  end
end
