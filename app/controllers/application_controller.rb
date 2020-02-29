class ApplicationController < ActionController::Base
  def authenticate_user!
    redirect_to new_session_path unless SessionsController.authenticate(session)
  end

  def header
    {
        'Content-Type': 'application/json',
        'Authorization': session['token_type'] + ' ' + session['access_token']
    }
  end
end
