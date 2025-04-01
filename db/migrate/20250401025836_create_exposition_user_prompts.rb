class CreateExpositionUserPrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_user_prompts do |t|
      t.references :exposition_system_prompt, foreign_key: { on_delete: :restrict }
      t.text :content, null: false

      t.timestamps
    end
  end
end
