# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Customers' do
  let(:user) { create(:user) }
  let(:customer) { create(:customer, created_by: user) }
  let(:valid_attributes) do
    {
      name: 'John',
      surname: 'Doe',
      photo: fixture_file_upload(Rails.root.join('spec/fixtures/files/photo.jpg'), 'image/jpg')
    }
  end
  let(:invalid_attributes) { { name: '', surname: '' } }
  let(:token) { generate_token_for(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/customers' do
    it 'returns a success response' do
      get(api_v1_customers_path, headers:)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/customers/:id' do
    it 'returns a success response' do
      get(api_v1_customer_path(customer), headers:)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /api/v1/customers' do
    context 'with valid parameters' do
      it 'creates a new Customer' do
        expect do
          post '/api/v1/customers', params: { customer: valid_attributes }, headers:
        end.to change(Customer, :count).by(1)

        if response.status != 201
          puts "Response status: #{response.status}"
          puts "Response body: #{response.body}"
          puts "Errors: #{Customer.last&.errors&.full_messages}"
        end

        expect(response).to have_http_status(:created)
        expect(Customer.last.created_by).to eq(user)
        expect(Customer.last.last_modified_by).to eq(user)
      end
    end

    context 'with invalid parameters' do
      it 'returns an unprocessable entity response' do
        post api_v1_customers_path, params: { customer: invalid_attributes }, headers:, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /api/v1/customers/:id' do
    context 'with valid parameters' do
      let(:new_attributes) { { name: 'Updated Name' } }

      it 'updates the requested customer' do
        patch api_v1_customer_path(customer), params: { customer: new_attributes }, headers:, as: :json
        customer.reload
        expect(customer.name).to eq('Updated Name')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'returns an unprocessable entity response' do
        patch api_v1_customer_path(customer), params: { customer: invalid_attributes }, headers:, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/customers/:id' do
    it 'destroys the requested customer' do
      customer_to_delete = create(:customer, created_by: user)
      expect do
        delete api_v1_customer_path(customer_to_delete), headers:
      end.to change(Customer, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
