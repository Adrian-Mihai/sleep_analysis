module Api
  module V1
    module SleepAnalysis
      class StatisticsController < Api::ApiController
        def index
          statistics_service = Analysis::GenerateStatistics.new(user_id: user.id,
                                                                x_axis: params[:x],
                                                                y_axis: params[:y],
                                                                start_date: params[:start],
                                                                end_date: params[:end]).perform
          raise ServiceError, statistics_service unless statistics_service.valid?

          render json: {}, status: :ok
        end
      end
    end
  end
end
