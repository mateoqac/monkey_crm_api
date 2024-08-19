require 'rails_helper'

RSpec.describe Customers::UpdateCustomer do
  let(:user) { create(:user) }
  let(:customer) { create(:customer, created_by: user) }
  let(:valid_params) { { name: 'Updated Name' } }
  let(:invalid_params) { { name: '' } }

  context 'when parameters are valid' do
    it 'updates the customer' do
      result = described_class.new.call(customer, valid_params, user)
      expect(result.success?).to be(true)
      expect(customer.reload.name).to eq('Updated Name')
    end
  end

  context 'when parameters are invalid' do
    it 'returns failure' do
      result = described_class.new.call(customer, invalid_params, user)
      expect(result.success?).to be(false)
    end
  end
end
