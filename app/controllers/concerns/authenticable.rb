module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    decoded = decoded_token
    return render json: { errors: 'Unauthorized' }, status: :unauthorized if decoded.nil?

    jti = decoded[:jti]

    if BlacklistedToken.exists?(jti:)
      render json: { errors: 'Token has been blacklisted' }, status: :unauthorized
    else
      @current_user = User.find(decoded[:user_id])
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Unauthorized' }, status: :unauthorized
  end

  def decoded_token
    header = request.headers['Authorization']
    token = header.split.last if header
    decoded = JwtService.decode(token)
    decoded&.symbolize_keys
  end

  def current_user
    @current_user
  end
end
