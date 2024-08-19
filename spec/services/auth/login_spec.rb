# spec/services/auth/login_spec.rb
require 'rails_helper'

RSpec.describe Auth::Login do
  let(:service) { described_class.new }
  let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  describe '#call' do
    context 'with valid credentials' do
      let(:params) { { email: user.email, password: 'password123' } }

      it 'returns a success monad' do
        result = service.call(params)
        expect(result).to be_success
      end

      it 'returns the user and a token' do
        result = service.call(params)
        expect(result.value![:user]).to eq(user)
        expect(result.value![:token]).to be_a(String)
      end

      it 'generates a valid JWT token' do
        result = service.call(params)
        token = result.value![:token]
        decoded_token = JwtService.decode(token)
        expect(decoded_token[:user_id]).to eq(user.id)
        expect(decoded_token[:jti]).to be_present
      end
    end

    context 'with invalid email' do
      let(:params) { { email: 'wrong@example.com', password: 'password123' } }

      it 'returns a failure monad' do
        result = service.call(params)
        expect(result).to be_failure
      end

      it 'returns an error message' do
        result = service.call(params)
        expect(result.failure).to eq('User not found')
      end
    end

    context 'with invalid password' do
      let(:params) { { email: user.email, password: 'wrongpassword' } }

      it 'returns a failure monad' do
        result = service.call(params)
        expect(result).to be_failure
      end

      it 'returns an error message' do
        result = service.call(params)
        expect(result.failure).to eq('Invalid password')
      end
    end
  end
end
