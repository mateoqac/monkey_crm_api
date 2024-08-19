# frozen_string_literal: true

module Customers
  class DeletePhoto
    include Dry::Monads[:result]

    def call(customer)
      return Failure('Customer not found') unless customer
      return Failure('No photo attached') unless customer.photo.attached?

      begin
        attachment = ActiveStorage::Attachment.find_by(record: customer, name: 'photo')

        if attachment
          attachment.purge
          Success(customer)
        else
          Failure('Photo attachment not found')
        end
      end
    end
  end
end
