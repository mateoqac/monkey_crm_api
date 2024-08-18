module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authorize_request, only: [:logout]

      def signup
        result = Users::Signup.new.call(user_params)

        if result.success?
          render json: serialize_user(result.value![:user], result.value![:token]), status: :created
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def login
        result = Users::Login.new.call(login_params)

        if result.success?
          render json: serialize_user(result.value![:user], result.value![:token]), status: :ok
        else
          render json: { errors: result.failure }, status: :unauthorized
        end
      end

      def logout
        header = request.headers['Authorization']
        token = header.split.last if header

        result = Users::Logout.new.call(token)

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

      def user_params
        params.permit(:name, :email, :password, :password_confirmation)
      end

      def login_params
        params.require(:authentication).permit(:email, :password)
      end
    end
  end
end
