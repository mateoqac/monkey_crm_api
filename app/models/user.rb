# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  rolify
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { email.present? }
end
