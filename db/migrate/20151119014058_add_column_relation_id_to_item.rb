class AddColumnRelationIdToItem < ActiveRecord::Migration
  def change
    add_column :items, :relationship_id, :integer
  end
end
