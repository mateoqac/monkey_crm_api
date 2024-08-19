# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    trait :admin do
      after(:create) do |user|
        user.add_role(:admin) if user.roles.empty?
      end
    end

    trait :superadmin do
      after(:create) do |user|
        user.add_role(:superadmin) if user.roles.empty?
      end
    end
  end
end
