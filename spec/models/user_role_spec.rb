# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserRole do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:role) }
  end

  describe 'validations' do
    subject { build(:user_role) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:role_id) }
  end

  describe 'creation' do
    let(:user) { create(:user) }
    let(:role) { create(:role) }

    it 'is valid with valid attributes' do
      user_role = described_class.new(user:, role:)
      expect(user_role).to be_valid
    end

    it 'is not valid without a user' do
      user_role = described_class.new(role:)
      expect(user_role).not_to be_valid
    end

    it 'is not valid without a role' do
      user_role = described_class.new(user:)
      expect(user_role).not_to be_valid
    end

    it 'does not allow duplicate user-role combinations' do
      described_class.create(user:, role:)
      duplicate_user_role = described_class.new(user:, role:)
      expect(duplicate_user_role).not_to be_valid
    end
  end
end
