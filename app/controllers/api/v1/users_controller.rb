# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!
      before_action :find_user, only: %i[show update destroy add_admin_role remove_admin_role]
      after_action :verify_authorized

      def index
        authorize User
        @users = policy_scope(User)
        render json: UserSerializer.new(@users).serializable_hash.to_json
      end

      def show
        authorize @user
        render json: UserSerializer.new(@user).serializable_hash.to_json
      end

      def create
        authorize User
        result = Users::CreateUser.new.call(user_params)

        if result.success?
          render json: UserSerializer.new(result.value!).serializable_hash.to_json, status: :created
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def update
        authorize @user
        result = Users::UpdateUser.new.call(@user, user_params)

        if result.success?
          render json: UserSerializer.new(result.value!).serializable_hash.to_json, status: :ok
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @user
        result = Users::DestroyUser.new.call(@user)

        if result.success?
          head :no_content
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def add_admin_role
        authorize @user, :add_admin_role?
        result = Users::AddAdminRole.new.call(@user)

        if result.success?
          render json: UserSerializer.new(result.value!).serializable_hash.to_json, status: :ok
        else
          render json: { errors: result.failure }, status: :unauthorized
        end
      end

      def remove_admin_role
        authorize @user, :remove_admin_role?
        result = Users::RemoveAdminRole.new.call(@user)

        if result.success?
          render json: UserSerializer.new(result.value!).serializable_hash.to_json, status: :ok
        else
          render json: { errors: result.failure }, status: :unauthorized
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def find_user
        @user = User.find(params[:id])
      end
    end
  end
end
