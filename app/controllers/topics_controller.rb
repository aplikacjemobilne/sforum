class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  before_action :require_token, only: [:create]
  swagger_controller :topics, 'Topics'

  # GET /topics/1
  # GET /topics/1.json
  swagger_api :show do
    summary 'Returns one topic'
    param :path, :course_id, :integer, :required, "Course id"
    param :path, :id, :integer, :required, "Topic id"
    notes 'Notes...'
  end
  def show
  end

  # GET /topics/new
  def new
    @course = Course.find(params[:course_id])
    @topic = @course.topics.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  swagger_api :create do
    summary "Create new topic"
    param :header, "Authorization", :string, :required, "Authentication token"
    param :path, :course_id, :integer, :required, "Course id"
    param :form, "topic[title]", :string, :required, "Title of a topic"
  end
  def create
    @course = Course.find(params[:course_id])
    @topic = @course.topics.new(topic_params)
    @topic.student = current_student

    respond_to do |format|
      if @topic.save
        format.html { redirect_to [@course, @topic], notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  swagger_api :update do
    summary "Update a topic"
    param :path, :id, :integer, :required, "Topic id"
    param :path, :course_id, :integer, :required, "Course id"
    param :form, "topic[title]", :string, :required, "Topic title"
  end
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to [@course, @topic], notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  swagger_api :destroy do
    summary 'Destroys a topic'
    param :path, :id, :integer, :required, "Topic id"
    param :path, :course_id, :integer, :required, "Course id"
    notes 'Notes...'
  end
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @course = Course.find(params[:course_id])
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :student_id, :course_id)
    end
end
