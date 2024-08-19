# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customers::CreateCustomer do
  let(:user) { create(:user) }
  let(:valid_params) do
    { name: 'John', surname: 'Doe', id: '12345', photo: fixture_file_upload('spec/fixtures/files/photo.jpg') }
  end
  let(:invalid_params) { { name: '', surname: '', id: '' } }

  context 'when parameters are valid' do
    it 'creates a new customer' do
      result = described_class.new.call(valid_params, user)
      expect(result.success?).to be(true)
      expect(Customer.count).to eq(1)
    end
  end

  context 'when parameters are invalid' do
    it 'returns failure' do
      result = described_class.new.call(invalid_params, user)
      expect(result.success?).to be(false)
      expect(Customer.count).to eq(0)
    end
  end
end
