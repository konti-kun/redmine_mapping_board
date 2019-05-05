migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration
class AddDefaultToNotesXy <  migration_class
  def change                                           
    change_column_default(:notes, :x, 0)
    change_column_default(:notes, :y, 0)
  end

end
