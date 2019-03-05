migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration

class DropTablePositions < migration_class
  def change
    drop_table :positions
  end
end
