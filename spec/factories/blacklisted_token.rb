# frozen_string_literal: true

FactoryBot.define do
  factory :blacklisted_token do
    jti { SecureRandom.uuid }
  end
end
