class RemoveOldTables < ActiveRecord::Migration
  def change
    drop_table :checklists
    drop_table :checklist_items
  end
end
