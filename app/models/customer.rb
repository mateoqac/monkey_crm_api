# app/models/customer.rb
class Customer < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  belongs_to :last_modified_by, class_name: 'User', optional: true

  has_one_attached :photo

  validates :photo, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                    size: { less_than: 2.megabytes }
  validates :name, presence: true
  validates :surname, presence: true
  validates :photo, presence: true
end
