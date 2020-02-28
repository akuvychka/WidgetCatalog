class ApplicationController < ActionController::Base
  def authenticate_user!
    redirect_to new_session_path unless SessionsController.authenticate(session)
  end
end
