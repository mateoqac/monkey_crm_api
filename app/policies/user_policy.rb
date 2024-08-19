# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def admin_or_superadmin?
    user.has_role?(:admin) || user.has_role?(:superadmin)
  end

  alias index? admin_or_superadmin?
  alias show? admin_or_superadmin?
  alias create? admin_or_superadmin?
  alias update? admin_or_superadmin?
  alias destroy? admin_or_superadmin?
  alias add_admin_role? admin_or_superadmin?

  def remove_admin_role?
    user.has_role?(:superadmin)
  end

  class Scope < Scope
    def resolve
      if user.has_role?(:superadmin)
        scope.all
      elsif user.has_role?(:admin)
        scope.where.not(id: User.with_role(:superadmin).pluck(:id))
      else
        scope.none
      end
    end
  end
end
