# spec/services/auth/logout_spec.rb
require 'rails_helper'

RSpec.describe Auth::Logout do
  let(:service) { described_class.new }
  let(:user) { create(:user) }
  let(:valid_token) { JwtService.encode({ user_id: user.id, jti: SecureRandom.uuid }) }

  describe '#call' do
    context 'with a valid token' do
      it 'returns a success monad' do
        result = service.call(valid_token)
        expect(result).to be_success
      end

      it 'returns a success message' do
        result = service.call(valid_token)
        expect(result.value!).to eq('Logged out successfully')
      end

      it 'creates a blacklisted token' do
        expect { service.call(valid_token) }.to change(BlacklistedToken, :count).by(1)
      end

      it 'blacklists the correct jti' do
        service.call(valid_token)
        decoded_token = JwtService.decode(valid_token)
        expect(BlacklistedToken.last.jti).to eq(decoded_token[:jti])
      end
    end

    context 'with a blank token' do
      it 'returns a failure monad' do
        result = service.call('')
        expect(result).to be_failure
      end

      it 'returns an error message' do
        result = service.call('')
        expect(result.failure).to eq('No token provided')
      end

      it 'does not create a blacklisted token' do
        expect { service.call('') }.not_to change(BlacklistedToken, :count)
      end
    end

    context 'with an invalid token' do
      let(:invalid_token) { 'invalid.token.here' }

      it 'returns a failure monad' do
        result = service.call(invalid_token)
        expect(result).to be_failure
      end

      it 'returns an error message' do
        result = service.call(invalid_token)
        expect(result.failure).to eq('Invalid token')
      end

      it 'does not create a blacklisted token' do
        expect { service.call(invalid_token) }.not_to change(BlacklistedToken, :count)
      end
    end
  end
end
