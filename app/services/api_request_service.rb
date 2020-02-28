class ApiRequestService
  def initialize(command, header, data = null)
    @command = command
    @header = header
    @data = data
  end

  def get
    begin
      RestClient.get ENV['API_HOST'] + @command, @header
    rescue RestClient::ExceptionWithResponse => err
      puts err
    end
  end

  def post
    begin
      puts ENV['API_HOST'] + @command
      puts @data.to_json
      res = RestClient.post ENV['API_HOST'] + @command, @data.to_json, @header
      puts res
      res
    rescue RestClient::ExceptionWithResponse => err
      puts 'OME ERR'
      puts err.message
    end
  end
end
