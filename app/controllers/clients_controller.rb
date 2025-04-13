class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_client

  def show
    @user = current_user
    @contracts = @user.contracts.order(created_at: :desc)
    @request = Request.new
    @request.build_technical_request
    @request.build_course_content_request
  end

  def create_request
    @request = current_user.requests.build(request_params)
    @request.status = 'pending'

    if @request.save
      render json: { success: true, message: 'Request submitted successfully' }
    else
      render json: { success: false, message: 'Failed to submit request' }, status: :unprocessable_entity
    end
  end

  def index
    show
  end

  private

  def ensure_client
    unless current_user.client?
      redirect_to root_path, alert: 'Access denied. Client area only.'
    end
  end

  def request_params
    params.require(:request).permit(
      :request_type,
      technical_request_attributes: [:description],
      course_content_request_attributes: [:course, :category, :description]
    )
  end
end
