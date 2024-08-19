require 'rails_helper'

RSpec.describe 'Api::V1::Authentication', type: :request do
  let(:user) { create(:user, password: 'password123') }
  let(:valid_login_params) { { authentication: { email: user.email, password: 'password123' } } }
  let(:invalid_login_params) { { authentication: { email: user.email, password: 'wrongpassword' } } }

  describe 'POST /api/v1/auth/login' do
    context 'with valid credentials' do
      it 'returns a success response' do
        post api_v1_auth_login_path, params: valid_login_params
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user data and token' do
        post api_v1_auth_login_path, params: valid_login_params
        json_response = JSON.parse(response.body)
        expect(json_response['data']['attributes']).to include('name', 'email', 'token')
        expect(json_response['data']['attributes']['email']).to eq(user.email)
        expect(json_response['data']['attributes']['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns an unauthorized status' do
        post api_v1_auth_login_path, params: invalid_login_params
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        post api_v1_auth_login_path, params: invalid_login_params
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to be_present
      end
    end
  end

  describe 'POST /api/v1/auth/logout' do
    let(:auth_token) do
      post api_v1_auth_login_path, params: valid_login_params
      JSON.parse(response.body)['data']['attributes']['token']
    end

    context 'with a valid token' do
      it 'returns a success response' do
        post api_v1_auth_logout_path, headers: { 'Authorization' => "Bearer #{auth_token}" }
        expect(response).to have_http_status(:ok)
      end

      it 'returns a success message' do
        post api_v1_auth_logout_path, headers: { 'Authorization' => "Bearer #{auth_token}" }
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Logged out successfully')
      end
    end

    context 'with an invalid token' do
      it 'returns an unauthorized status' do
        post api_v1_auth_logout_path, headers: { 'Authorization' => 'Bearer invalid_token' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
