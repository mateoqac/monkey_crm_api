# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a name' do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
  end
end
