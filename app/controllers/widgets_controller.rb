class WidgetsController  < ApplicationController
  before_action :authenticate_user!
  before_action :get_widgets, only: [:index, :destroy]
  before_action :get_widget, only: [:edit]
  before_action :get_id, only: [:destroy]

  def index
  end

  def new
  end

  def edit
  end

  def show
  end

  def create
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'widgets', header, new_widget_params).post
    respond_to do |format|
      if response && response['code'].to_i == 0
        format.html { redirect_to my_widgets_path, notice: response['message'] }
      else
        error_handler(response)
        format.html { render new_widget_path }
      end
    end
  end

  def update
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, "widgets/#{params['widget_id']}", header, update_widget_params).put
    respond_to do |format|
      if response && response['code'].to_i == 0
        format.html { redirect_to my_widgets_path, notice: response['message'] }
      else
        error_handler(response)
        @widget = params
        format.html { redirect_to edit_widget_path(@widget['name']) }
      end
    end
  end

  def destroy
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, "widgets/#{@id}", header).delete
    respond_to do |format|
      unless response && response['code'].to_i == 0
        error_handler(response)
      end
      format.js
    end
  end

  private

  def get_widgets
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'widgets/visible', header, widgets_params(params[:search])).get
    if response && response['code'].to_i == 0
      @widgets = response['data']['widgets']
    else
      error_handler(response)
    end
  end

  def widgets_params(term = nil)
    request_params = {
        'client_id': ENV['CLIENT_ID'],
        'client_secret': ENV['CLIENT_SECRET']
    }
    request_params[:term] = term if term.present?
    request_params
  end

  def get_widget
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users/me/widgets', header, widgets_params(params[:id])).get
    if response && response['code'].to_i == 0
      @widget = response['data']['widgets'][0]
      @widget['widget_id'] = @widget['id']
    else
      error_handler(response)
    end
  end

  def new_widget_params
    {
        widget: {
            name: params['name'],
            description: params['description'],
            kind: params['visibility'].to_i == 0 ? "hidden" : "visible"
        }
    }
  end

  def update_widget_params
    {
        widget: {
            name: params['name'],
            description: params['description']
        }
    }
  end

  def get_id
    @id = params[:id]
  end
end