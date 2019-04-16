migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration
class CreateMappingimages < migration_class
  def change
    create_table :mappingimages do |t|
      t.string :url
      t.integer :x, null: false, default: 0
      t.integer :y, null: false, default: 0
      t.integer :width, null: false, default: 10
      t.integer :height, null: false, default: 10
      t.belongs_to :mappingboard, index: true, foreign_key: true
    end
  end
end
