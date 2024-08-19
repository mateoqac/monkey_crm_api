# frozen_string_literal: true

module Customers
  class UploadPhoto
    include Dry::Monads[:result]

    def call(customer, photo)
      return Failure('Customer not found') unless customer
      return Failure('Photo is required') unless photo

      if customer.photo.attach(photo)
        Success(customer)
      else
        Failure(customer.errors.full_messages)
      end
    end
  end
end
