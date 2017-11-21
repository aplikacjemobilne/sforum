class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  swagger_controller :session, "Authentication"
  before_action :require_token, only: [:destroy]

  def new

  end

  swagger_api :create do
    summary "Gather a token"
    param :form, "session[index]", :string, :required, "Students index"
    param :form, "session[password]", :string, :required, "Students password"
  end
  def create
    respond_to do |format|
      student = Student.find_by(index: params[:session][:index])
      if student && student.authenticate(params[:session][:password])
        format.html do
          log_in student
          redirect_to student
        end
        format.json do
          student.password = params[:session][:password]
          student.regenerate_token
          render json: { token: student.token }
        end
      else
        format.html do
          render 'new'
        end
        format.json do
          render json: { message: 'Niepoprawne dane' }
        end
      end
    end
 end

  swagger_api :destroy do
    summary "Invalidate a token"
    param :header, "Authorization", :string, :required, "Authentication token"
  end
  def destroy
    respond_to do |format|
      format.html do
        log_out
        redirect_to root_url
      end
      format.json do
        require_token
        if current_student
          current_student.invalidate_token
          head :ok
        end
      end
    end
  end
end
