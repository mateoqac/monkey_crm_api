# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customers::UploadPhoto do
  let(:service) { described_class.new }
  let(:customer) { create(:customer) }
  let(:photo) { fixture_file_upload('spec/fixtures/files/photo.jpg', 'image/jpg') }

  describe '#call' do
    context 'when customer and photo are provided' do
      it 'attaches the photo to the customer' do
        result = service.call(customer, photo)
        expect(result).to be_success
        expect(customer.photo).to be_attached
      end
    end

    context 'when customer is not provided' do
      it 'returns a failure' do
        result = service.call(nil, photo)
        expect(result).to be_failure
      end
    end

    context 'when photo is not provided' do
      it 'returns a failure' do
        result = service.call(customer, nil)
        expect(result).to be_failure
      end
    end
  end
end
