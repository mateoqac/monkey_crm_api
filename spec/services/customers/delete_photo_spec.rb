# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Customers::DeletePhoto do
  let(:service) { described_class.new }
  let!(:customer) { create(:customer, :with_photo) }

  describe '#call' do
    context 'when customer has a photo attached' do
      it 'deletes the photo' do
        expect(customer.photo).to be_attached
        expect(ActiveStorage::Attachment.count).to eq(1)
        expect(ActiveStorage::Blob.count).to eq(1)

        result = service.call(customer)

        expect(result).to be_success
        customer.reload
        expect(customer.photo).not_to be_attached
        expect(ActiveStorage::Attachment.count).to eq(0)
        expect(ActiveStorage::Blob.count).to eq(0)
      end
    end

    context 'when customer does not have a photo attached' do
      let!(:customer_without_photo) { create(:customer) }

      it 'returns a failure' do
        result = service.call(customer_without_photo)

        expect(result).to be_failure
        expect(result.failure).to eq('No photo attached')
      end
    end

    context 'when customer is not found' do
      it 'returns a failure' do
        result = service.call(nil)

        expect(result).to be_failure
        expect(result.failure).to eq('Customer not found')
      end
    end
  end
end
