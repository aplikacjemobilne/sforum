require "rails_helper"

RSpec.describe "Topics", :type => :request do
  before(:each) do
    objects = RequestsHelper.prepare_requests()
    @student = objects[:student]
    @course = objects[:course]
    @topic = objects[:topic]
  end

  it "receives a particular topic" do
    get "/courses/#{@course.id}/topics/#{@topic.id}", headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(json['id']).to eq(@topic.id)
    expect(json['title']).to eq(@topic.title)
    expect(json['student_id']).to eq(@student.id)
    expect(json['course_id']).to eq(@course.id)
    expect(response).to have_http_status(200)
  end

  it "creates a topic" do
    post "/courses/#{@course.id}/topics", params:
    {
      topic: {
        title: 'A whole new topic'
      }
    }, headers: {
      'Accept' => 'application/json',
      'Authorization' => "Token #{@student.token}"
    }

    json = JSON(response.body)

    expect(response).to have_http_status(201)
    expect(json['title']).to eq('A whole new topic')
    expect(json['student_id']).to eq(@student.id)
    expect(json['course_id']).to eq(@course.id)
  end

  it "updates a topic" do
    patch "/courses/#{@course.id}/topics/#{@topic.id}", params:
    {
      topic: {
        title: 'Changed title'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(200)
    expect(@topic.title).not_to eq(json['title'])
    @topic.reload
    expect(@topic.title).to eq(json['title'])
    expect(json['title']).to eq('Changed title')

  end

  it "deletes a topic" do
    expect(Topic.exists?(@topic.id)).to eq(true)
    delete "/courses/#{@course.id}/topics/#{@topic.id}", headers:
    {
      'Accept' => 'application/json'
    }

    expect(response).to have_http_status(204)
    expect(Topic.exists?(@topic.id)).to eq(false)
  end
end
