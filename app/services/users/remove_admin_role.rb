# frozen_string_literal: true

# app/services/users/remove_admin_role.rb
module Users
  class RemoveAdminRole
    include Dry::Monads[:result]

    def call(user)
      user.remove_role(:admin)
      Success(user)
    end
  end
end
