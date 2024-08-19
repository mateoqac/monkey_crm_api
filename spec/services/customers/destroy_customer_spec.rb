# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customers::DestroyCustomer do
  let(:user) { create(:user) }
  let!(:customer) { create(:customer, created_by: user) }

  it 'destroys the customer' do
    result = described_class.new.call(customer)
    expect(result.success?).to be(true)
    expect(Customer.exists?(customer.id)).to be(false)
  end
end
