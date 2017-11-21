class AddTokenToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :token, :string
    add_index :students, :token
  end
end
