class AuthController < ApplicationController
  skip_before_action :authorize_request, only: %i[login]

  def login
    user = User.find_by(email: login_params[:email])
  
    if user&.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
