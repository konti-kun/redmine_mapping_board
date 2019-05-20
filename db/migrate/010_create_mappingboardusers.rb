migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration
class CreateMappingboardusers < migration_class
  def change
    create_table :mappingboardusers do |t|
      t.belongs_to :mappingboard, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
    end

  end
  def up
    remove_column :mappingboards, :is_current
  end

  def down
    add_column :mappingboards, "is_current",:boolean, default: false
  end
end
