class CoursesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_course, only: [:show, :edit, :update, :destroy, :follow, :unfollow]
  before_action :require_token, only: [:follow, :unfollow]
  swagger_controller :courses, 'Courses'

  swagger_api :follow do
    summary 'Follows a course'
    notes 'Notes...'
    param :header, "Authorization", :string, :required, "Authentication token"
    param :path, :id, :integer, :required, "Course id"
  end
  def follow
    unless current_student.follows?(@course)
      current_student.courses.append(@course)
    end
    redirect_to @course
  end

  swagger_api :unfollow do
    summary 'Unfollows a course'
    notes 'Notes...'
    param :header, "Authorization", :string, :required, "Authentication token"
    param :path, :id, :integer, :required, "Course id"
  end
  def unfollow
    if current_student.follows?(@course)
      @course.students.delete(current_student)
    end
    redirect_to @course
  end

  # GET /courses
  # GET /courses.json
  swagger_api :index do
    summary 'Returns all courses'
    notes 'Notes...'
  end
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  swagger_api :show do
    summary 'Returns one course'
    param :path, :id, :integer, :required, "Course id"
    notes 'Notes...'
  end
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  swagger_api :create do
    summary "Create a course"
    param :form, "course[name]", :string, :required, "Course name"
    param :form, "course[code]", :string, :required, "Course code"
    param :form, "course[description]", :string, :required, "Course description"
  end
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  swagger_api :update do
    summary "Update a course"
    param :path, :id, :integer, :required, "Course id"
    param :form, "course[name]", :string, :required, "Course name"
    param :form, "course[code]", :string, :required, "Course code"
    param :form, "course[description]", :string, :required, "Course description"
  end
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  swagger_api :destroy do
    summary 'Destroys a course'
    param :path, :id, :integer, :required, "Course id"
    notes 'Notes...'
  end
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :code, :description)
    end
end
