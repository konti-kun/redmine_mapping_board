class DropTablePositions < ActiveRecord::Migration
  def change
    drop_table :positions
  end
end
