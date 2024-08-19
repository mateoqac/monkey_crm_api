# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  belongs_to :last_modified_by, class_name: 'User', optional: true

  has_one_attached :photo

  validates :photo, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                    size: { less_than: 2.megabytes },
                    if: :photo_attached?

  validates :name, presence: true
  validates :surname, presence: true

  private

  def photo_attached?
    photo.attached?
  end
end
