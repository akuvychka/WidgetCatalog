class PasswordsController < ApplicationController
  before_action :get_personal_info, only: [:update]
  before_action :authenticate_user!, only: [:edit, :update]
  def edit
  end

  def forgot
  end

  def update
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
          error_handler(response)
          format.html { render :edit_password }
        end
      end
    end
  end

  def restore
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users/reset_password', simple_header, restore_password_params).post
    if response && response['code'].to_i == 0
      redirect_to new_session_path, notice: response['message']
    else
      error_handler(response)
    end
  end

  private

  def password_update_params
    {
        'user': params.permit('new_password', 'current_password')
    }
  end

  def restore_password_params
    {
        'client_id': ENV['CLIENT_ID'],
        'client_secret': ENV['CLIENT_SECRET'],
        'user': params.permit('email')
    }
  end
end