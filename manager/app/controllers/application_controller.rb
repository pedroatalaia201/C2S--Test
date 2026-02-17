class ApplicationController < ActionController::API
  before_action :authenticate!

  # Don't if this will be needed yet...
  # attr_reader :current_user

  private

  def authenticate!
    token = request.headers['Auth-token'].to_s
    return render json: { error: 'missing token' }, status: :unauthorized if token.blank?

    data = AuthServiceClient.new.verify(token: token)
    return render json: { error: 'Invalid token' }, status: :unauthorized if data.nil?

    # It'll get the response of the /auth/verify
    @current_user = data
  end
end
