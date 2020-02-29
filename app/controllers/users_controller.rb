class UsersController < ApplicationController
  before_action :get_personal_info, only: [:me, :edit, :save_password]
  before_action :authenticate_user!, except: [:new, :create]

  def new
  end

  def create
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users', { 'Content-Type': 'application/json' }, new_user_params).post
    respond_to do |format|
      if response && response['code'].to_i == 0
        SessionsController.store_session(response['data']['token'], session)
        format.html { redirect_to widgets_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: {error: 'Some error, will remove later'}, status: :unprocessable_entity }
      end
    end
  end

  def me
  end

  def edit
  end

  def update
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users/me', header, update_user_params).put
    @user = params.permit('first_name', 'last_name', 'email', 'date_of_birth', 'image_url', 'id')
    @user['images'] = { original_url: params[:image_url] }
    respond_to do |format|
      if response && response['code'].to_i == 0
        format.html { redirect_to me_users_path, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: {error: 'Some error, will remove later'}, status: :unprocessable_entity }
      end
    end
  end

  def edit_password
  end

  def save_password
    respond_to do |format|
      if params[:new_password] == params[:current_password]
        @error = { message: "new password shouldn't be equal current"}
        format.html { render :edit_password }
      elsif params[:new_password] != params[:confirm_your_password]
        @error = { message: "new password does not equal confirmation"}
        format.html { render :edit_password }
      else
        response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users/me/password', header, password_update_params).post
        if response && response['code'].to_i == 0
          SessionsController.store_session(response['data']['token'], session)
          format.html { redirect_to me_users_path, notice: 'Password was successfully updated.' }
        else
          format.html { render :edit_password }
        end
      end
    end
  end

  private

  def new_user_params
    {
        'client_id': ENV['CLIENT_ID'],
        'client_secret': ENV['CLIENT_SECRET'],
        'user': params.permit('first_name', 'last_name', 'email', 'password', 'image_url')
    }
  end

  def update_user_params
    {
        'user': params.permit('first_name', 'last_name', 'email', 'date_of_birth', 'image_url')
    }
  end

  def password_update_params
    {
        'user': params.permit('new_password', 'current_password')
    }
  end

  def get_personal_info
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users/me', { 'Authorization': session['token_type'] + ' ' + session[:access_token] }).get
    if response && response['code'].to_i == 0
      @user = response['data']['user']
    end
  end

end