# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    created_by { create(:user) }

    trait :with_photo do
      after(:create) do |customer|
        file_path = Rails.root.join('spec/fixtures/files/photo.jpg')

        if File.exist?(file_path)
          begin
            file = File.open(file_path)
            customer.photo.attach(io: file, filename: 'photo.jpg', content_type: 'image/jpeg')
            customer.save!
          ensure
            file&.close
          end
        end
      end
    end
  end
end
