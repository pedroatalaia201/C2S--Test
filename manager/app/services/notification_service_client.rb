class NotificationServiceClient
  def initialize(base_url: ENV.fetch('NOTIFICATION_SERVICE_URL'))
    @connection = Faraday.new(url: base_url) do |conn|
      conn.request  :json
      conn.response :raise_error
    end
  end

  def create(task_id:, event_type:, collected_data:, user_id:, user_email: )
    resp = @connection.post('/notifications') do |req|
      req.body = { 
        task_id: task_id, event_type: event_type, 
        collected_data: collected_data,
        user_id: user_id, user_email: user_email
       }.to_json
    end
        
    return true if resp[:status].to_i == 201
  rescue Faraday::Error
    nil
  end
end
