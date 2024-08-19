# frozen_string_literal: true

class CustomerSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :surname

  attribute :photo_url do |customer|
    if customer.photo.attached?
      Rails.application.routes.url_helpers.rails_blob_path(customer.photo, disposition: 'attachment', only_path: true)
    end
  end
end
