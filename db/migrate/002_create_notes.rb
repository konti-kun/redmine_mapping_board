migration_class = ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration

class CreateNotes < migration_class
  def change
    create_table :notes do |t|
      t.integer :number
      t.integer :x
      t.integer :y
      t.belongs_to :project, index: true, foreign_key: true
      t.belongs_to :issue, index: true, foreign_key: true
    end
  end
end
