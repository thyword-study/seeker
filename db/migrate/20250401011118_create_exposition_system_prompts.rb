class CreateExpositionSystemPrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_system_prompts do |t|
      t.text :text, null: false

      t.timestamps
    end
  end
end
