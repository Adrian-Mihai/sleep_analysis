module Api
  module V1
    module SleepAnalysis
      class StatisticsController < Api::ApiController
        before_action :find_user

        def index
          statistics_service = Analysis::GenerateStatistics.new(user_id: @user.id,
                                                                x_axis: params[:x],
                                                                y_axis: params[:y],
                                                                start_date: params[:start],
                                                                end_date: params[:end]).perform
          raise ServiceError, statistics_service unless statistics_service.valid?

          render json: statistics_service.data, status: :ok
        end

        private

        def find_user
          @user = User.find(params[:user_id])
        end
      end
    end
  end
end
