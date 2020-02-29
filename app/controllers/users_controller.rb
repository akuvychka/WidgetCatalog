class UsersController < ApplicationController
  before_action :get_personal_info, only: [:me, :edit]
  before_action :authenticate_user!, except: [:new, :create]

  def new
  end

  def create
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users', simple_header, new_user_params).post
    respond_to do |format|
      if response && response['code'].to_i == 0
        SessionsController.store_session(response['data']['token'], session)
        format.html { redirect_to widgets_path, notice: 'User was successfully created.' }
      else
        error_handler(response)
        format.html { render :new }
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
        error_handler(response)
        format.html { render :edit }
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

end