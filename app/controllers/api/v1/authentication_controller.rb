module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_user!, only: %i[login]

      def login
        result = Auth::Login.new.call(login_params)

        if result.success?
          render json: serialize_user(result.value![:user], result.value![:token]), status: :ok
        else
          render json: { errors: result.failure }, status: :unauthorized
        end
      end

      def logout
        result = Auth::Logout.new.call(extract_token)

        if result.success?
          render json: { message: result.value! }, status: :ok
        else
          render json: { errors: result.failure }, status: :unauthorized
        end
      end

      private

      def serialize_user(user, token)
        serialized_user = UserSerializer.new(user).serializable_hash
        serialized_user[:data][:attributes][:token] = token
        serialized_user
      end

      def login_params
        params.require(:authentication).permit(:email, :password)
      end

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def extract_token
        request.headers['Authorization']&.split&.last
      end
    end
  end
end
