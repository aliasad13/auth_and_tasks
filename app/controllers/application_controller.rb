class ApplicationController < ActionController::API
  before_action :authorize_request!

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request!
    token = request.headers['Authorization']&.split(' ')&.last
    begin
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base).first
      @current_user = User.find(decoded_token['user_id'])
    rescue JWT::DecodeError
      render json: { errors: ['Unauthorized'] }, status: :unauthorized
    end
  end
end
