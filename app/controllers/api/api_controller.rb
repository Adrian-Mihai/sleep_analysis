module Api
  class ApiController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error
    rescue_from ServiceError, with: :service_invalid_error
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_error

    private

    def record_not_found_error(error)
      logger.error("Error: #{error.inspect}\nBacktrace: #{error.backtrace.join("\n \t")}")
      render json: { messages: ["#{error.model} not found"] }, status: :not_found
    end

    def record_invalid_error(error)
      logger.error("Error: #{error.inspect}\nBacktrace: #{error.backtrace.join("\n \t")}")
      render json: { messages: error.record.errors.full_messages }, status: :unprocessable_entity
    end

    def service_invalid_error(error)
      logger.error("Error: #{error.inspect}\nBacktrace: #{error.backtrace.join("\n \t")}")
      render json: { messages: error.service.errors }, status: :unprocessable_entity
    end
  end
end
