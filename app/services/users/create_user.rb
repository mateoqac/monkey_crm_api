module Users
  class CreateUser
    include Dry::Monads[:result]

    def call(params)
      user = User.new(params)

      if user.save
        Success(user)
      else
        Failure(user.errors.full_messages)
      end
    end
  end
end
