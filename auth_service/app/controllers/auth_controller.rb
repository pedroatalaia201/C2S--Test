class AuthController < ApplicationController
  skip_before_action :authorize_request, only: %i[sign_up sign_in]

  # POST /auth/sign_up
  def sign_up
    user = User.new(**user_params)

    if user.save
      render json: user, serializer: SimpleUserSerializer
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /auth/sign_in
  def sign_in
    user = User.find_by(email: user_params[:email])
  
    if user&.authenticate(user_params[:password])
      token = JsonWebToken.encode(user_id: user.id)

      render json: user, token: token, exp_in: 60.minutes.from_now.to_i,
      serializer: UserWithExpTokenSerializer, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # POST /auth/verify
  def verify
    # If the token expire the :authorize_request will deal with that.
    render json: @current_user, serializer: SimpleUserSerializer
  end

  private

  # It'll be used for both sign_up and sign_in
  def user_params
    params.permit(:name, :email, :password)
  end
end
