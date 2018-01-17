require "rails_helper"

module RequestsHelper
  def self.prepare_requests
    # Usuwamy wszystkie obiekty, klasa po klasie
    Student.all.destroy_all
    Course.all.destroy_all
    Topic.all.destroy_all
    Post.all.destroy_all

    # Tworzymy nowego studenta, zapisujemy go i uzyskujemy token
    student = Student.new(
      index: "123456",
      name:"Zenon",
      password: "haslo123"
    )
    student.save!
    student.regenerate_token
    student.reload

    # Tworzymy i zapisujemy w bazie nowy kurs
    course = Course.new(
      name: "Nazwa kursu",
      code:"INEU1234",
      description: "Opis kursu"
    )
    course.save!

    # Tworzymy i zapisujemy w bazie nowy temat
    topic = Topic.new(
      course: course,
      student: student,
      title: 'Tytuł tematu'
    )
    topic.save!

    # Tworzymy i zapisujemy w bazie nowy post
    post = Post.new(
      topic: topic,
      student: student,
      body: 'Przykładowy post'
    )
    post.save!

    # Zwracamy słownik z utworzonymi obiektami
    return {
      student: student,
      course: course,
      topic: topic,
      post: post
    }
  end
end
