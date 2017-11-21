class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :require_token, only: [:create]
  swagger_controller :posts, 'Posts'


  swagger_api :show do
    summary 'Returns one post'
    param :path, :course_id, :integer, :required, "Course id"
    param :path, :topic_id, :integer, :required, "Topic id"
    param :path, :id, :integer, :required, "Post id"
    notes 'Notes...'
  end
  def show
  end

  # GET /posts/new
  def new
    @course = Course.find(params[:course_id])
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  swagger_api :create do
    summary "Create new post"
    param :header, "Authorization", :string, :required, "Authentication token"
    param :path, :course_id, :integer, :required, "Course id"
    param :path, :topic_id, :integer, :required, "Topic id"
    param :form, "post[body]", :string, :required, "Body of a post"
  end
  def create
    @course = Course.find(params[:course_id])
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.new(post_params)
    @post.student = current_student

    respond_to do |format|
      if @post.save
        format.html { redirect_to [@course, @topic], notice: 'Post was successfully created.' }
        format.json { render :show, status: :created}
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  swagger_api :update do
    summary "Update a post"
    param :path, :id, :integer, :required, "Post id"
    param :path, :topic_id, :integer, :required, "Topic id"
    param :path, :course_id, :integer, :required, "Course id"
    param :form, "post[body]", :string, :required, "Body of a post"
  end
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to [@course, @topic], notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  swagger_api :destroy do |post|
    summary 'Destroys a post'
    param :path, :id, :integer, :required, "Post id"
    param :path, :topic_id, :integer, :required, "Topic id"
    param :path, :course_id, :integer, :required, "Course id"
    notes 'Notes...'
  end
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @course = Course.find(params[:course_id])
      @topic = Topic.find(params[:topic_id])
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:body, :student_id, :topic_id)
    end
end
