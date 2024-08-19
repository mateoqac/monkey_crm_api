# frozen_string_literal: true

module Auth
  class Logout
    include Dry::Monads[:result]

    def call(token)
      return Failure('No token provided') if token.blank?

      decoded = JwtService.decode(token)
      return Failure('Invalid token') if decoded.nil?

      jti = decoded[:jti]
      BlacklistedToken.create(jti:)
      Success('Logged out successfully')
    end
  end
end
