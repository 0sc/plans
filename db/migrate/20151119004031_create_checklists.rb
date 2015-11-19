class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :name
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
