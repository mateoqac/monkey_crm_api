class ApplicationController < ActionController::API
  def authorize_request
    decoded = decoded_token
    jti = decoded[:jti]

    if BlacklistedToken.exists?(jti:)
      render json: { errors: 'Token has been blacklisted' }, status: :unauthorized
    else
      @current_user = User.find(decoded[:user_id])
    end
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { errors: 'Unauthorized' }, status: :unauthorized
  end

  private

  def decoded_token
    header = request.headers['Authorization']
    token = header.split.last if header
    decoded = JWT.decode(token, ENV.fetch('SECRET_KEY_BASE', Rails.application.credentials.secret_key_base))[0]
    decoded.symbolize_keys
  end
end
