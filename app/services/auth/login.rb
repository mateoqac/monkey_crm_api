# frozen_string_literal: true

# # app/services/auth/login.rb
# module Auth
#   class Login
#     include Dry::Monads[:result]

#     def call(params)
#       user = yield find_user(params[:email])
#       authenticated_user = yield authenticate_user(user, params[:password])
#       token = generate_token(authenticated_user)

#       Success({ user: authenticated_user, token: })
#     end

#     private

#     def find_user(email)
#       user = User.find_by(email:)
#       user ? Success(user) : Failure('User not found')
#     end

#     def authenticate_user(user, password)
#       user.authenticate(password) ? Success(user) : Failure('Invalid password')
#     end

#     def generate_token(user)
#       payload = { user_id: user.id, jti: SecureRandom.uuid }
#       JwtService.encode(payload)
#     end
#   end
# end

# app/services/auth/login.rb
module Auth
  class Login
    include Dry::Monads[:result]

    def call(params)
      find_user(params[:email]).bind do |user|
        authenticate_user(user, params[:password]).fmap do |authenticated_user|
          token = generate_token(authenticated_user)
          { user: authenticated_user, token: }
        end
      end
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
      JwtService.encode(payload)
    end
  end
end
