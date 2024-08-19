# frozen_string_literal: true

module Users
  class RemoveAdminRole
    include Dry::Monads[:result]

    def call(user)
      user.remove_role(:admin)
      Success(user)
    end
  end
end
