class ApiRequestService
  OAUTH_REQUEST_TYPE = 'oauth/'
  API_REQUEST_TYPE = 'api/v1/'

  def initialize(type, command, header, data = nil)
    @type = type
    @command = command
    @header = header
    @data = data
  end

  def get
    begin
      res = RestClient.get ENV['API_HOST'] + @type + @command, @header
      puts res
      JSON.parse(res.body)
    rescue RestClient::ExceptionWithResponse => err
      JSON.parse(err.response)
    end
  end

  def post
    begin
      res = RestClient.post ENV['API_HOST'] + @type + @command, @data.to_json, @header
      puts res
      JSON.parse(res.body)
    rescue RestClient::ExceptionWithResponse => err
      JSON.parse(err.response)
    end
  end

  def put
    begin
      res = RestClient.put ENV['API_HOST'] + @type + @command, @data.to_json, @header
      puts res
      JSON.parse(res.body)
    rescue RestClient::ExceptionWithResponse => err
      JSON.parse(err.response)
    end
  end
end
