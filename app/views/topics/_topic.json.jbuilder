json.extract! topic, :id, :title, :student_id, :course_id, :created_at, :updated_at
json.posts topic.posts do |post|
  json.id post.id
  json.body post.body
  json.student_id post.student.id
end
