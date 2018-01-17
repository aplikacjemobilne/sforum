require "rails_helper"

RSpec.describe "Courses", :type => :request do
  before(:each) do
    objects = RequestsHelper.prepare_requests()
    @student = objects[:student]
    @course = objects[:course]
  end

  it "receives list of courses" do
    get "/courses", headers: {'Accept' => 'application/json'}
    expect(response).to have_http_status(200)
  end

  it "receives a particular course" do
    get "/courses/#{@course.id}", headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(json['id']).to eq(@course.id)
    expect(json['name']).to eq(@course.name)
    expect(json['code']).to eq(@course.code)
    expect(json['description']).to eq(@course.description)
    expect(response).to have_http_status(200)
  end

  it "follows a course" do
    expect(@course.students.exists?(@student.id)).to eq(false)
    get "/courses/#{@course.id}/follow", headers: {
      'Authorization' => "Token #{@student.token}",
      'Accept' => 'application/json'
    }
    expect(@course.students.exists?(@student.id)).to eq(true)
  end

  it "unfollows a course" do
    @course.students.append(@student)

    expect(@course.students.exists?(@student.id)).to eq(true)

    get "/courses/#{@course.id}/unfollow", headers: {
      'Authorization' => "Token #{@student.token}",
      'Accept' => 'application/json'
    }

    expect(@course.students.exists?(@student.id)).to eq(false)
  end

  it "creates a course" do
    post "/courses", params:
    {
      course: {
        name: 'New name',
        code: 'New code',
        description: 'New description'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(201)
    expect(json['name']).to eq('New name')
    expect(json['code']).to eq('New code')
    expect(json['description']).to eq('New description')
  end

  it "updates a course" do
    patch "/courses/#{@course.id}", params:
    {
      course: {
        name: 'Another name'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(200)
    expect(@course.name).not_to eq(json['name'])
    @course.reload
    expect(@course.name).to eq(json['name'])
    expect(json['name']).to eq('Another name')

  end

  it "deletes a course" do
    expect(Course.exists?(@course.id)).to eq(true)
    delete "/courses/#{@course.id}", headers:
    {
      'Accept' => 'application/json'
    }

    expect(response).to have_http_status(204)
    expect(Course.exists?(@course.id)).to eq(false)
  end
end
