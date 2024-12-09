class AuthController < ApplicationController
  skip_before_action :authorize_request!, only: [:register, ""]

  before_action :user_params, only: [:register]

  def register
    user = User.new(user_params)
    if user.save
      render json: {message: "Signed Up Successfully"}, status: 200
    else
      render json: user.errors.full_messages, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user
      if user.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: {token: token}, status: 200
      else
        render json: {error: "Password Invalid"}, status: 401
      end
    else
      render json: {errors: "User not found"}, status: 404
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :status)
  end
end