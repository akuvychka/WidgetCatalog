class SessionsController < ApplicationController
  class << self
    def authenticate(session)
      @session = session
      check_session
    end

    def store_session(token, session)
      session[:access_token] = token['access_token']
      session[:token_type] = token['token_type']
      session[:expires_in] = token['expires_in']
      session[:refresh_token] = token['refresh_token']
      session[:created_at] = token['created_at']
    end

    private

    def check_session
      return false unless @session[:expires_in].present? && @session[:created_at].present?
      DateTime.now.to_i < @session[:created_at].to_i + @session[:expires_in].to_i
    end
  end

  def new
  end

  def create
    res = ApiRequestService.new(ApiRequestService::OAUTH_REQUEST_TYPE,'token', { 'Content-Type': 'application/json' }, new_session_params).post
    respond_to do |format|
      if res && res['code'].to_i == 0
        SessionsController.store_session(res['data']['token'], session)
        format.html { redirect_to widgets_path, notice: 'Logged in successfully.' }
      else
        error_handler(response)
        format.html { redirect_to new_session_path, notice: 'Wrong user email or password' }
      end
    end
  end

  def destroy
    ApiRequestService.new(ApiRequestService::OAUTH_REQUEST_TYPE,'revoke', header, { token: session[:access_token]}).post
    clear_session
    redirect_to new_session_path
  end

  private

  def clear_session
    session[:access_token] = nil
    session[:token_type] = nil
    session[:expires_in] = nil
    session[:refresh_token] = nil
    session[:created_at] = nil
  end

  def new_session_params
    {
        'grant_type': 'password',
        'client_id': ENV['CLIENT_ID'],
        'client_secret': ENV['CLIENT_SECRET'],
        'username': params[:email],
        'password': params[:password]
    }
  end
end