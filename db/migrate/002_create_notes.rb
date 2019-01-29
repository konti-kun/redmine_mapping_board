class CreateNotes < ActiveRecord::Migration
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
