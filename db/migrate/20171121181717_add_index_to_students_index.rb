class AddIndexToStudentsIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :students, :index, unique: true
  end
end
