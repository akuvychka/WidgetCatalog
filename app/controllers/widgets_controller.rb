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
        format.html { redirect_to widgets_path, notice: response['message'] }
      else
        error_handler(response)
        format.html { render new_widget_path }
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

  def get_id
    @id = params[:id]
  end
end