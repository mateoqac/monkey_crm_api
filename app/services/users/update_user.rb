
module Users
  class UpdateUser
    include Dry::Monads[:result]

    def call(user, params)
      if user.update(params)
        Success(user)
      else
        Failure(user.errors.full_messages)
      end
    end
  end
end
