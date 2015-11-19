class RenameTableItemsToLists < ActiveRecord::Migration
  def change
    rename_table :items, :lists
  end
end
