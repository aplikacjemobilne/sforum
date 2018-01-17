require "rails_helper"

RSpec.describe "Posts", :type => :request do
  before(:each) do
    objects = RequestsHelper.prepare_requests()
    @student = objects[:student]
    @course = objects[:course]
    @topic = objects[:topic]
    @post = objects[:post]
  end

  it "receives a particular post" do
    get "/courses/#{@course.id}/topics/#{@topic.id}/posts/#{@post.id}", headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(json['id']).to eq(@post.id)
    expect(json['body']).to eq(@post.body)
    expect(json['student_id']).to eq(@student.id)
    expect(json['topic_id']).to eq(@topic.id)
    expect(response).to have_http_status(200)
  end

  it "creates a post" do
    post "/courses/#{@course.id}/topics/#{@topic.id}/posts", params:
    {
      post: {
        body: 'A whole new post'
      }
    }, headers: {
      'Accept' => 'application/json',
      'Authorization' => "Token #{@student.token}"
    }

    json = JSON(response.body)

    expect(response).to have_http_status(201)
    expect(json['body']).to eq('A whole new post')
    expect(json['student_id']).to eq(@student.id)
    expect(json['topic_id']).to eq(@topic.id)
  end

  it "updates a post" do
    patch "/courses/#{@course.id}/topics/#{@topic.id}/posts/#{@post.id}", params:
    {
      post: {
        body: 'Changed body'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(200)
    expect(@post.body).not_to eq(json['body'])
    @post.reload
    expect(@post.body).to eq(json['body'])
    expect(json['body']).to eq('Changed body')

  end

  it "deletes a post" do
    expect(Post.exists?(@post.id)).to eq(true)
    delete "/courses/#{@course.id}/topics/#{@topic.id}/posts/#{@post.id}", headers:
    {
      'Accept' => 'application/json'
    }

    expect(response).to have_http_status(204)
    expect(Post.exists?(@post.id)).to eq(false)
  end
end
