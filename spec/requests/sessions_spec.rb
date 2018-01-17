require "rails_helper"

RSpec.describe "Session management", :type => :request do
  before(:each) do
    objects = RequestsHelper.prepare_requests()
    @student = objects[:student]
  end

  it "does not pass after wrong credentials" do
    post "/login", params:
    {
      session: {
        index: @student.index,
        password: 'wrongPassword'
      }
    }, headers: { 'Accept' => 'application/json' }

    @expected = {
        :message  => "Niepoprawne dane"
    }.to_json

    expect(response.body).to eq @expected
  end

  it "receives a correct token after correct credentials" do
    post "/login", params:
    {
      session: {
        index: @student.index,
        password: @student.password
      }
    }, headers: { 'Accept' => 'application/json' }
    @student.reload

    @expected = {
        :token  => @student.token
    }.to_json

    expect(response.body).to eq @expected
  end

  it "deletes a token after logout with correct credentials" do
    expect(@student.token).not_to be_nil

    delete "/logout", headers: {
      'Accept' => 'application/json',
      'Authorization' => "Token #{@student.token}"
    }

    @student.reload

    expect(@student.token).to be_nil
  end
end
