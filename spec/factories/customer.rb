FactoryBot.define do
  factory :customer do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    sequence(:id) { |n| "CUST#{n}" }

    created_by { create(:user) }

    after(:build) do |customer|
      customer.photo.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/photo.jpg')),
        filename: 'photo.jpg',
        content_type: 'image/jpg'
      )
    end
  end
end
