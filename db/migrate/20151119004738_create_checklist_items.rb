class CreateBucketlistItems < ActiveRecord::Migration
  def change
    create_table :bucketlist_items do |t|
      t.boolean :done, default: false
      t.string :name
      t.references :bucketlist, index: true

      t.timestamps null: false
    end
  end
end
