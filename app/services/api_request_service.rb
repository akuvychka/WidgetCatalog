class ApiRequestService
  OAUTH_REQUEST_TYPE = 'oauth/'
  API_REQUEST_TYPE = 'api/v1/'

  def initialize(type, command, header, data = null)
    @type = type
    @command = command
    @header = header
    @data = data
  end

  def get
    begin
      RestClient.get ENV['API_HOST'] + @type + @command, @header
    rescue RestClient::ExceptionWithResponse => err
      puts err
    end
  end

  def post
    begin
      res = RestClient.post ENV['API_HOST'] + @type + @command, @data.to_json, @header
      puts res
      JSON.parse(res.body)
    rescue RestClient::ExceptionWithResponse => err
      puts 'OME ERR'
      puts err.message
    end
  end
end
