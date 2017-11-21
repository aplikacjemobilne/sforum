json.courses current_student.courses do |course|
  json.id course.id
  json.name course.name
  json.description course.description
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
end
