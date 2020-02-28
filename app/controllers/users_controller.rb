class UsersController < ApplicationController
  def sign_in
  end

  def new
  end

  def create
    response = ApiRequestService.new('users', { 'Content-Type': 'application/json' }, new_user_params).post
    puts response
    respond_to do |format|
      if response
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
#{"code":0,"message":"Success","data":{"user":{"id":2379,"name":"Test Test","images":{"small_url":"https://showoff-rails-react-api-production.s3.amazonaws.com/users/images/missing/missing.jpg","medium_url":"https://showoff-rails-react-api-production.s3.amazonaws.com/users/images/missing/missing.jpg","large_url":"https://showoff-rails-react-api-production.s3.amazonaws.com/users/images/missing/missing.jpg","original_url":"https://showoff-rails-react-api-production.s3.amazonaws.com/users/images/missing/missing.jpg"},"first_name":"Test","last_name":"Test","date_of_birth":null,"email":"deep.winnie@mail.com","active":true},"token":{"access_token":"d370053b813fed72bf166ab80875db70511493c01219048dd7a9d9519978a142","token_type":"Bearer","expires_in":2592000,"refresh_token":"9e72649959502e331359f70c3d2e6608fe70b5c76b9d6b3e30236d5631a6a26e","scope":"basic","created_at":1582879811}}}
end