class Student < ApplicationRecord
  has_and_belongs_to_many :courses, :join_table => :students_courses
  has_many :topics
  has_many :posts

  has_secure_password

  validates :name, presence: true, uniqueness: true, length: { in: 3..50 }
  validates :index, presence: true, length: { is: 6 }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end
