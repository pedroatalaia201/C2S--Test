class AuthServiceClient
  def initialize(base_url: ENV.fetch('AUTH_SERVICE_URL'))
    @connection = Faraday.new(url: base_url) do |f|
      f.request  :json
      f.response :raise_error
    end
  end

  def verify(token:)
    resp = @connection.get('/auth/verify') do |req|
      req.headers['Auth-token'] = token
    end

    JSON.parse(resp.body)
  rescue Faraday::Error
    nil
  end
end