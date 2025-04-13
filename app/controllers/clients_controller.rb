class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_client

  def show
    @user = current_user
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
end
