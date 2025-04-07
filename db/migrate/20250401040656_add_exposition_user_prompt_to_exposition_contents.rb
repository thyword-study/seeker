class AddExpositionUserPromptToExpositionContents < ActiveRecord::Migration[8.0]
  def change
    add_reference :exposition_contents, :user_prompt, null: false, foreign_key: { on_delete: :restrict, to_table: :exposition_user_prompts }
  end
end
