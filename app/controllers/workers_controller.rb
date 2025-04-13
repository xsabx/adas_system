class WorkersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_worker

  def show
    @user = current_user
  end

  def index
    show
  end

  private

  def ensure_worker
    unless current_user.worker?
      redirect_to root_path, alert: 'Access denied. Worker area only.'
    end
  end
end
