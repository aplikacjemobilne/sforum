class StaticController < ApplicationController
  before_action :require_token, only: [:feed]
  swagger_controller :static, 'Static'

  def index
    @students = Student.all
    @courses = Course.all
  end

  swagger_api :feed do
    summary "Shows a feed for authenticated used"
    param :header, "Authorization", :string, :required, "Authentication token"
  end
  def feed

  end
end
