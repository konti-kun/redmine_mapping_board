migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration
class RemoveDefaultToMappingimagesSize <  migration_class
  def change                                           
    change_column(:mappingimages, :width, :integer, null: true)
    change_column(:mappingimages, :height, :integer, null: true)
    change_column_default(:mappingimages, :width, nil)
    change_column_default(:mappingimages, :height, nil)
  end
end
