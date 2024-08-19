# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }

    created_by { create(:user) }

    after(:build) do |customer|
      customer.photo.attach(
        io: Rails.root.join('spec/fixtures/files/photo.jpg').open,
        filename: 'photo.jpg',
        content_type: 'image/jpg'
      )
    end
  end
end
