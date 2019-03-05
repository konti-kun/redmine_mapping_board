migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration

class CreatePositions < migration_class
  def change
    create_table :positions do |t|
      t.integer :number
      t.integer :x
      t.integer :y
    end
  end
end
