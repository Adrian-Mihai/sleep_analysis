module Api
  module V1
    module SleepAnalysis
      class AveragesController < Api::ApiController
        def index
          average_service = Analysis::CalculateAverageData.new(user_id: user.id,
                                                               start_date: params[:start],
                                                               end_date: params[:end],
                                                               day: params[:day]).perform
          unless average_service.valid?
            render json: { messages: average_service.errors }, status: :unprocessable_entity
            return
          end

          render json: Average.new(average_service.data), status: :ok
        rescue ActiveRecord::RecordNotFound => e
          render json: { messages: ["#{e.model} not found"] }, status: :unprocessable_entity
        end

        private

        def user
          return @user if defined? @user

          @user = User.find(params[:user_id])
        end
      end
    end
  end
end
