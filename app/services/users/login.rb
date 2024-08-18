# app/services/users/login.rb
module Users
  class Login
    include Dry::Monads[:result, :do]

    def call(params)
      user = yield find_user(params[:email])
      authenticated_user = yield authenticate_user(user, params[:password])
      token = yield generate_token(authenticated_user)

      Success({ user: authenticated_user, token: })
    end

    private

    def find_user(email)
      user = User.find_by(email:)
      user ? Success(user) : Failure('User not found')
    end

    def authenticate_user(user, password)
      user.authenticate(password) ? Success(user) : Failure('Invalid password')
    end

    def generate_token(user)
      payload = { user_id: user.id, jti: SecureRandom.uuid }
      token = JWT.encode(payload, ENV.fetch('SECRET_KEY_BASE', Rails.application.credentials.secret_key_base))
      Success(token)
    end
  end
end
