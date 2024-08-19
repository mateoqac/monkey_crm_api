# frozen_string_literal: true

class CustomerPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.present?
  end

  def destroy?
    user.present?
  end

  def upload_photo?
    user.present?
  end

  def delete_photo?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
