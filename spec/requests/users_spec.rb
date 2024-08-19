# frozen_string_literal: true

require 'rails_helper'
require 'debug'
RSpec.describe 'Api::V1::Users' do
  let!(:admin) { create(:user, :admin) }
  let!(:superadmin) { create(:user, :superadmin) }
  let!(:regular_user) { create(:user) }
  let(:token) { generate_token_for(admin) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/users' do
    it 'returns a list of users' do
      get(api_v1_users_path, headers:)
      expect(response).to have_http_status(:success)
      expect(json_response_body['data']).to be_an(Array)
      expect(json_response_body['data'].first['type']).to eq('user')
    end
  end

  describe 'GET /api/v1/users/:id' do
    it 'returns a specific user' do
      get(api_v1_user_path(regular_user), headers:)
      expect(response).to have_http_status(:success)
      expect(json_response_body['data']['id']).to eq(regular_user.id.to_s)
      expect(json_response_body['data']['type']).to eq('user')
      expect(json_response_body['data']['attributes']['name']).to eq(regular_user.name)
      expect(json_response_body['data']['attributes']['email']).to eq(regular_user.email)
    end
  end

  describe 'POST /api/v1/users' do
    let(:valid_attributes) do
      {
        user: {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          password: 'Password123!',
          password_confirmation: 'Password123!'
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          name: nil,
          email: nil,
          password: 'short',
          password_confirmation: 'not_matching'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post '/api/v1/users', params: valid_attributes, headers:
        end.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(json_response_body['data']['type']).to eq('user')
        expect(json_response_body['data']['attributes']['email']).to eq(valid_attributes[:user][:email])
        expect(json_response_body['data']['attributes']['name']).to eq(valid_attributes[:user][:name])
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post '/api/v1/users', params: invalid_attributes, headers:
        end.not_to change(User, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response_body['errors']).to be_present
      end
    end
  end

  describe 'PATCH /api/v1/users/:id' do
    let(:new_attributes) { { user: { name: 'New Name' } } }

    it 'updates the requested user' do
      patch(api_v1_user_path(regular_user), params: new_attributes, headers:)
      expect(response).to have_http_status(:ok)
      expect(json_response_body['data']['attributes']['name']).to eq('New Name')
      expect(regular_user.reload.name).to eq('New Name')
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    it 'destroys the requested user' do
      user_to_delete = create(:user)
      expect do
        delete api_v1_user_path(user_to_delete), headers:
      end.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'POST /api/v1/users/:id/add_admin_role' do
    context 'when current user is a superadmin' do
      let(:token) { generate_token_for(superadmin) }

      it 'adds admin role to the user' do
        post(add_admin_role_api_v1_user_path(regular_user), headers:)
        expect(response).to have_http_status(:ok)
        expect(json_response_body['data']['id']).to eq(regular_user.id.to_s)
        expect(regular_user.reload.has_role?(:admin)).to be true
      end
    end

    context 'when current user is not a admin' do
      let(:token) { generate_token_for(regular_user) }

      it 'does not add admin role to the user' do
        user_to_be_admin = create(:user)
        post(add_admin_role_api_v1_user_path(user_to_be_admin), headers:)
        expect(response).to have_http_status(:forbidden)
        expect(user_to_be_admin.reload.has_role?(:admin)).to be false
      end
    end
  end

  describe 'POST /api/v1/users/:id/remove_admin_role' do
    let(:admin_user) { create(:user, :admin) }

    context 'when current user is a superadmin' do
      let(:token) { generate_token_for(superadmin) }

      it 'removes admin role from the user' do
        post(remove_admin_role_api_v1_user_path(admin_user), headers:)
        expect(response).to have_http_status(:ok)
        expect(json_response_body['data']['id']).to eq(admin_user.id.to_s)
        expect(admin_user.reload.has_role?(:admin)).to be false
      end
    end

    context 'when current user is not a superadmin' do
      let(:token) { generate_token_for(regular_user) }

      it 'does not remove admin role from the user' do
        post(remove_admin_role_api_v1_user_path(admin_user), headers:)
        expect(response).to have_http_status(:forbidden)
        expect(admin_user.reload.has_role?(:admin)).to be true
      end
    end
  end
end
