class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :number
      t.integer :x
      t.integer :y
    end
  end
end
