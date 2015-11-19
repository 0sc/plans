class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :type
      t.string :name
      t.boolean :done, default: false
      t.timestamps null: false
    end
  end
end
