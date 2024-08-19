# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "role_#{n}" }

    trait :admin do
      name { 'admin' }
    end

    trait :superadmin do
      name { 'superadmin' }
    end
  end
end
