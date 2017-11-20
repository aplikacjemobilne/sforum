class Topic < ApplicationRecord
  belongs_to :student
  belongs_to :course
  has_many :posts
end
