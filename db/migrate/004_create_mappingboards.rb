migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration
class CreateMappingboards < migration_class
  def change
    create_table :mappingboards do |t|
      t.string :name
      t.belongs_to :project, index: true, foreign_key: true
    end

    add_reference :notes, :mappingboard, foreign_key: true
    remove_reference :notes, :project, foreign_key: true

    add_index :notes, [:mappingboard_id, :issue_id], :unique => true
    add_index :notes, [:mappingboard_id, :number], :unique => true
  end
end
