# app/services/users/logout.rb
module Users
  class Logout
    include Dry::Monads[:result]

    def call(token)
      jti = decoded_jti(token)
      blacklist_token(jti)
      Success('Logged out successfully')
    end

    private

    def decoded_jti(token)
      decoded_token = JWT.decode(token, ENV.fetch('SECRET_KEY_BASE', Rails.application.credentials.secret_key_base))[0]
      decoded_token['jti']
    end

    def blacklist_token(jti)
      BlacklistedToken.create(jti:)
    end
  end
end
