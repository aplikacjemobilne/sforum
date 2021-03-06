class StudentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  swagger_controller :students, 'Students'

  # GET /students
  # GET /students.json
  swagger_api :index do
    summary 'Returns all students'
    notes 'Notes...'
  end
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  swagger_api :show do
    summary 'Returns one student'
    param :path, :id, :integer, :required, "Students id"
    notes 'Notes...'
  end
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  swagger_api :create do
    summary "Create a student"
    param :form, "student[name]", :string, :required, "Students name"
    param :form, "student[index]", :string, :required, "Students index"
    param :form, "student[password]", :string, :required, "Students password"
  end
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  swagger_api :update do
    summary "Update a student"
    param :path, :id, :integer, :required, "Students id"
    param :form, "student[name]", :string, :required, "Students name"
    param :form, "student[index]", :string, :required, "Students index"
    param :form, "student[password]", :string, :required, "Students password"
  end
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  swagger_api :destroy do
    summary 'Destroys a student'
    param :path, :id, :integer, :required, "Students id"
    notes 'Notes...'
  end
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:index, :name, :password, :password_confirmation)
    end
end
