# frozen_string_literal: true

module Customers
  class DestroyCustomer
    include Dry::Monads[:result]

    def call(customer)
      if customer.destroy
        Success('Customer deleted successfully')
      else
        Failure('Failed to delete customer')
      end
    end
  end
end
