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

  def simple_header
    {
        'Content-Type': 'application/json'
    }
  end

  def auth_header
    {
        'Authorization': session['token_type'] + ' ' + session['access_token']
    }
  end

  def error_handler(response)
    if response['code'].to_i == 10
      redirect_to new_session_path, notice: "Your session was expired. Please sign in"
    end
  end

  def get_personal_info
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users/me', auth_header).get
    if response && response['code'].to_i == 0
      @user = response['data']['user']
    else
      error_handler(response)
    end
  end
end
