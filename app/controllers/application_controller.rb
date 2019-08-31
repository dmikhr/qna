class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.json { render json: { error: exception.message }, status: 403 }
      format.js { render nothing: true, status: 403 }
    end
  end

  check_authorization unless: :devise_controller?
end
