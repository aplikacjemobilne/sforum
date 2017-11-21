class StaticController < ApplicationController
  before_action :require_token, only: [:feed]
  def index
    @students = Student.all
    @courses = Course.all
  end

  def feed

  end
end
