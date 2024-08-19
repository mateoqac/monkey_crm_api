# app/serializers/customer_serializer.rb
class CustomerSerializer
  include JSONAPI::Serializer

  attributes :name, :surname, :photo_url

  attribute :photo_url do |customer|
    Rails.application.routes.url_helpers.rails_blob_url(customer.photo, only_path: true) if customer.photo.attached?
  end
end
