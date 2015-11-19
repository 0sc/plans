class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.boolean :done, default: false
      t.string :name
      t.references :checklist, index: true

      t.timestamps null: false
    end
  end
end
