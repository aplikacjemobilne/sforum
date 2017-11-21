json.extract! course, :id, :name, :code, :description, :created_at, :updated_at
json.url course_url(course, format: :json)
json.topics course.topics do |topic|
  json.id topic.id
  json.title topic.title
  json.student_id topic.student.id
  json.posts topic.posts do |post|
    json.id post.id
    json.body post.body
    json.student_id post.student.id
  end
end
