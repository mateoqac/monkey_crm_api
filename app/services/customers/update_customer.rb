# app/services/customers/update_customer.rb
module Customers
  class UpdateCustomer
    include Dry::Monads[:result]

    def call(customer, params, user)
      if customer.update(params)
        customer.update(last_modified_by: user)
        Success(customer)
      else
        Failure(customer.errors.full_messages)
      end
    end
  end
end
