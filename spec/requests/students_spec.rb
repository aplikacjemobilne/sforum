require "rails_helper"

RSpec.describe "Students", :type => :request do
  before(:each) do
    objects = RequestsHelper.prepare_requests()
    @student = objects[:student]
  end

  it "receives list of students" do
    get "/students", headers: {'Accept' => 'application/json'}
    expect(response).to have_http_status(200)
  end

  it "receives a particular student" do
    get "/students/#{@student.id}", headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(json['id']).to eq(@student.id)
    expect(json['index']).to eq(@student.index)
    expect(json['name']).to eq(@student.name)
    expect(response).to have_http_status(200)
  end

  it "creates a student" do
    post "/students", params:
    {
      student: {
        name: 'Alfred',
        index: '654321',
        password: 'password123'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(201)
    expect(json['name']).to eq('Alfred')
    expect(json['index']).to eq('654321')
  end

  it "updates a student" do
    patch "/students/#{@student.id}", params:
    {
      student: {
        name: 'Henryk',
        password: 'password123'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(200)
    expect(@student.name).not_to eq(json['name'])
    @student.reload
    expect(@student.name).to eq(json['name'])
    expect(json['name']).to eq('Henryk')

  end

  it "deletes a student" do
    expect(Student.exists?(@student.id)).to eq(true)
    delete "/students/#{@student.id}", headers:
    {
      'Accept' => 'application/json'
    }

    expect(response).to have_http_status(204)
    expect(Student.exists?(@student.id)).to eq(false)
  end
end
