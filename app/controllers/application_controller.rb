class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    if resource.client?
      clients_show_path
    elsif resource.worker?
      workers_show_path
    else
      root_path
    end
  end
end
