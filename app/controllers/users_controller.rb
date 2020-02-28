class UsersController < ApplicationController
  def new
  end

  def create
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users', { 'Content-Type': 'application/json' }, new_user_params).post
    puts response
    respond_to do |format|
      if response
        SessionsController.store_session(response[:data][:token], session)
        format.html { redirect_to widgets_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: {error: 'Some error, will remove later'}, status: :unprocessable_entity }
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
end