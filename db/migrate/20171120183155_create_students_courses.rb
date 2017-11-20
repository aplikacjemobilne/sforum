class CreateStudentsCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :students_courses, id: false do |t|
      t.belongs_to :student, index: true
      t.belongs_to :course, index: true
    end
  end
end
