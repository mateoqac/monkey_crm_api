module Users
  class AddAdminRole
    include Dry::Monads[:result]

    def call(user)
      user.add_role(:admin)
      Success(user)
    end
  end
end
