# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer do
  # Valid attributes
  let(:user) { create(:user) }
  let(:customer) { build(:customer, created_by: user) }

  it 'is valid with valid attributes' do
    expect(customer).to be_valid
  end

  it 'is not valid without a name' do
    customer.name = nil
    expect(customer).not_to be_valid
  end

  it 'is not valid without a surname' do
    customer.surname = nil
    expect(customer).not_to be_valid
  end

  it 'is not valid without a created_by' do
    customer.created_by = nil
    expect(customer).not_to be_valid
  end

  it 'is valid with a photo attachment' do
    customer.photo.attach(io: Rails.root.join('spec/fixtures/files/photo.jpg').open,
                          filename: 'photo.jpg', content_type: 'image/jpg')
    expect(customer).to be_valid
  end
end
