module AuthenticationHelper
  def generate_token_for(user)
    payload = { user_id: user.id, jti: SecureRandom.uuid }
    JWT.encode(payload, ENV.fetch('SECRET_KEY_BASE', Rails.application.credentials.secret_key_base))
  end
end
