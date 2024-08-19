require 'rails_helper'

RSpec.describe JwtService do
  let(:payload) { { user_id: 1, email: 'test@example.com' } }

  describe '.encode' do
    it 'encodes a payload into a JWT token' do
      token = JwtService.encode(payload)
      expect(token).to be_a(String)
      expect(token.split('.').length).to eq(3)
    end

    it 'includes an expiration time in the payload' do
      token = JwtService.encode(payload)
      decoded_payload = JWT.decode(token, JwtService::SECRET_KEY, true, algorithm: 'HS256')[0]
      expect(decoded_payload).to include('exp')
    end

    it 'allows custom expiration time' do
      custom_exp = 1.hour.from_now
      token = JwtService.encode(payload, custom_exp)
      decoded_payload = JWT.decode(token, JwtService::SECRET_KEY, true, algorithm: 'HS256')[0]
      expect(decoded_payload['exp']).to eq(custom_exp.to_i)
    end
  end

  describe '.decode' do
    it 'decodes a valid token' do
      token = JwtService.encode(payload)
      decoded_payload = JwtService.decode(token)
      expect(decoded_payload[:user_id]).to eq(payload[:user_id])
      expect(decoded_payload[:email]).to eq(payload[:email])
    end

    it 'returns nil for an invalid token' do
      expect(JwtService.decode('invalid.token')).to be_nil
    end

    it 'returns nil for an expired token' do
      expired_token = JwtService.encode(payload, 1.minute.ago)
      expect(JwtService.decode(expired_token)).to be_nil
    end

    it 'returns a HashWithIndifferentAccess' do
      token = JwtService.encode(payload)
      decoded_payload = JwtService.decode(token)
      expect(decoded_payload).to be_a(ActiveSupport::HashWithIndifferentAccess)
      expect(decoded_payload['user_id']).to eq(payload[:user_id])
      expect(decoded_payload[:user_id]).to eq(payload[:user_id])
    end
  end
end
