migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration
class RemoveToNotesNumber <  migration_class
  def up
    remove_index :notes, [:mappingboard_id, :number]
    remove_column :notes, :number
  end

  def down
    add_column :notes, :number, :integer
    add_index :notes, [:mappingboard_id, :number], :unique => true
  end
end
