class Course < ApplicationRecord
  has_and_belongs_to_many :students, :join_table => :students_courses
  has_many :topics
end
