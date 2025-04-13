class WorkersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_worker

  def show
    @user = current_user
    @pending_requests = Request.includes(:user, :technical_request, :course_content_request)
                              .where(status: 'pending')
                              .order(created_at: :desc)
  end

  def respond_to_request
    @request = Request.find(params[:request_id])
    @response = @request.build_response(
      user: current_user,
      content: params[:content]
    )

    if @response.save
      @request.update(status: 'responded')
      render json: { success: true, message: 'Response submitted successfully' }
    else
      render json: { 
        success: false, 
        message: 'Failed to submit response',
        errors: @response.errors.full_messages
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: 'Request not found' }, status: :not_found
  rescue StandardError => e
    render json: { success: false, message: 'An error occurred while processing your request' }, status: :internal_server_error
  end

  private

  def ensure_worker
    unless current_user.worker?
      redirect_to root_path, alert: 'Access denied. Worker area only.'
    end
  end
end
