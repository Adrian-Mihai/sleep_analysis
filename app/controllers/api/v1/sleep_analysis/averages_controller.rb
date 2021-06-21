module Api
  module V1
    module SleepAnalysis
      class AveragesController < Api::V1::AuthenticationController
        before_action :check_user_rights

        def index
          average_service = Analysis::CalculateAverageData.new(user_id: @user.id,
                                                               start_date: params[:start],
                                                               end_date: params[:end],
                                                               day: params[:day]).perform
          raise ServiceError, average_service unless average_service.valid?

          render json: Average.new(average_service.data), status: :ok
        end
      end
    end
  end
end
