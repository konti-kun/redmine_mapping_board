class CreateMappingimages < ActiveRecord::Migration
  def change
    create_table :mappingimages do |t|
      t.string :url
      t.integer :x, null: false, default: 0
      t.integer :y, null: false, default: 0
      t.integer :width, null: false, default: 10
      t.integer :height, null: false, default: 10
    end
  end
end
