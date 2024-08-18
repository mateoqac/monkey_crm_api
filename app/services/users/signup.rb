# app/services/users/signup.rb
module Users
  class Signup
    include Dry::Monads[:result, :do]

    def call(params)
      user = yield create_user(params)
      token = yield generate_token(user)

      Success({ user:, token: })
    end

    private

    def create_user(params)
      user = User.new(params)

      if user.save
        Success(user)
      else
        Failure(user.errors.full_messages)
      end
    end

    def generate_token(user)
      payload = { user_id: user.id, jti: SecureRandom.uuid }
      token = JWT.encode(payload, ENV.fetch('SECRET_KEY_BASE', Rails.application.credentials.secret_key_base))
      Success(token)
    end
  end
end
