# frozen_string_literal: true

module Users
  class DestroyUser
    include Dry::Monads[:result]

    def call(user)
      if user.destroy
        Success('User deleted successfully')
      else
        Failure('Failed to delete user')
      end
    end
  end
end
