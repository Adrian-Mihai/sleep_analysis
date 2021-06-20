module Api
  class ApiController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error
    rescue_from ServiceError, with: :service_invalid_error
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_error

    private

    def record_not_found_error(error)
      render json: { messages: ["#{error.model} not found"] }, status: :not_found
    end

    def record_invalid_error(error)
      render json: { messages: error.record.errors.full_messages }, status: :unprocessable_entity
    end

    def service_invalid_error(errors)
      render json: { messages: errors.service.errors }, status: :unprocessable_entity
    end
  end
end
