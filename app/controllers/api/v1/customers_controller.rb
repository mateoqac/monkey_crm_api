# frozen_string_literal: true

module Api
  module V1
    class CustomersController < ApplicationController
      before_action :authenticate_user!
      before_action :find_customer, only: %i[show update destroy upload_photo delete_photo]
      after_action :verify_authorized

      def index
        @customers = policy_scope(Customer)
        authorize Customer
        render json: CustomerSerializer.new(@customers).serializable_hash.to_json
      end

      def show
        authorize @customer
        render json: CustomerSerializer.new(@customer).serializable_hash.to_json
      end

      def create
        @customer = Customer.new(customer_params)
        authorize @customer
        result = Customers::CreateCustomer.new.call(customer_params, current_user)

        if result.success?
          render json: CustomerSerializer.new(result.value!).serializable_hash.to_json, status: :created
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def update
        authorize @customer
        result = Customers::UpdateCustomer.new.call(@customer, customer_params, current_user)

        if result.success?
          render json: CustomerSerializer.new(result.value!).serializable_hash.to_json, status: :ok
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @customer
        result = Customers::DestroyCustomer.new.call(@customer)

        if result.success?
          head :no_content
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def upload_photo
        authorize @customer

        result = Customers::UploadPhoto.new.call(@customer, params[:photo])

        if result.success?
          render json: CustomerSerializer.new(result.value!).serializable_hash.to_json, status: :ok
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      def delete_photo
        authorize @customer

        result = Customers::DeletePhoto.new.call(@customer)

        if result.success?
          head :no_content
        else
          render json: { errors: result.failure }, status: :unprocessable_entity
        end
      end

      private

      def customer_params
        params.require(:customer).permit(:name, :surname, :photo)
      end

      def find_customer
        @customer = Customer.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Customer not found' }, status: :not_found
      end
    end
  end
end
