class Api::V1::AuthController < ApplicationController
  skip_before_action :authorize_request!, only: [:register, :login, :refresh_token]

  before_action :user_params, only: [:register, :login, :refresh_token]

  def register
    user = User.new(user_params)
    if user.save
      access_token = encode_token({ user_id: user.id, exp: 1.hour.from_now.to_i })
      refresh_token = encode_token({ user_id: user.id, exp: 7.days.from_now.to_i })

      render json: { access_token: access_token,
                     refresh_token: refresh_token,
                     message: "Successful Registration"}, status: 200
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user
      if user.authenticate(params[:password])
        access_token = encode_token({ user_id: user.id, exp: 1.hour.from_now.to_i })
        refresh_token = encode_token({ user_id: user.id, exp: 7.days.from_now.to_i })

        render json: { access_token: access_token,
                       refresh_token: refresh_token,
                       message: "Login Successful"}, status: 200
      else
        render json: {error: "Password Invalid"}, status: 401
      end
    else
      render json: {errors: "User not found"}, status: 404
    end
  end

  def refresh_token
    refresh_token = request.headers['Authorization']&.split(' ')&.last
    begin
      decoded_token = JWT.decode(refresh_token, Rails.application.secrets.secret_key_base).first

      if decoded_token['exp'] < Time.now.to_i
        render json: { errors: ['Refresh token expired'] }, status: :unauthorized
        return
      end

      user = User.find(decoded_token['user_id'])
      access_token = encode_token({ user_id: user.id, exp: 1.hour.from_now.to_i })
      refresh_token = encode_token({ user_id: user.id, exp: 7.days.from_now.to_i })
      #creating refresh token everytime we create an access token, so the user wont be logged out and also the refresh token can keep changing
      render json: {
        access_token: access_token,
        refresh_token: refresh_token,
        message: "Access token refreshed" }, status: :ok

    rescue JWT::DecodeError
      render json: { errors: ['Invalid refresh token'] }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :phone, :status)
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

end