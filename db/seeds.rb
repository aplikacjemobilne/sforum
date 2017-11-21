students = Student.create(
  [
    {
      index: '123456',
      name: 'Zenon',
      password: 'haslo123'
    },
    {
      index: '654321',
      name: 'Marian',
      password: 'haslo123'
    }
  ]
)

courses = Course.create(
  [
    {
      code: '1234',
      name: 'Aplikacje mobilne',
      description: 'Opis kursu'
    },
    {
      code: '4321',
      name: 'Inny kurs',
      description: 'Opis innego kursu'
    }
  ]
)

topics = Topic.create(
  [
    {
      title: 'Co z tą Polską?',
      student: students.first,
      course: courses.first
    },
    {
      title: 'Jak żyć?',
      student: students.last,
      course: courses.first
    }
  ]
)

posts = Post.create(
  [
    {
      body: 'Sam nie wiem',
      student: students.first,
      topic: topics.first
    },
    {
      body: 'Ja też',
      student: students.last,
      topic: topics.first
    }
  ]
)

students.first.courses = courses
