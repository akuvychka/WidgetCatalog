class MyWidgetsController < WidgetsController

  private

  def get_widgets
    response = ApiRequestService.new(ApiRequestService::API_REQUEST_TYPE, 'users/me/widgets', header, widgets_params(params[:search])).get
    if response && response['code'].to_i == 0
      @widgets = response['data']['widgets']
    else
      error_handler(response)
    end
  end
end