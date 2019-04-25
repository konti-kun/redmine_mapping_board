migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration
class AddDefaultToMappingboardsName <  migration_class
  def change                                           
    change_column_default(:mappingboards, :name, "default")
    add_column :mappingboards, "is_current",:boolean, default: false
  end
end
