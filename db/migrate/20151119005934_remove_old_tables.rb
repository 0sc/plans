class RemoveOldTables < ActiveRecord::Migration
  def change
    drop_table :bucketlists
    drop_table :bucketlist_items
  end
end
