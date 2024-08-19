FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
  end

  trait :admin do
    after(:create) { |user| user.add_role(:admin) }
  end

  trait :superadmin do
    after(:create) { |user| user.add_role(:superadmin) }
  end
end
