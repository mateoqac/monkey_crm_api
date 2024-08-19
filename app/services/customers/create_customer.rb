module Customers
  class CreateCustomer
    include Dry::Monads[:result]

    def call(params, current_user)
      customer = Customer.new(params)
      customer.created_by = current_user
      customer.last_modified_by = current_user

      if customer.save
        Success(customer)
      else
        Failure(customer.errors.full_messages)
      end
    end
  end
end
