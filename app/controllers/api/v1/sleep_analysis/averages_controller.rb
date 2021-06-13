module Api
  module V1
    module SleepAnalysis
      class AveragesController < Api::ApiController
        def index
          average_service = Analysis::CalculateAverageData.new(user_id: user.id,
                                                               start_date: params[:start],
                                                               end_date: params[:end]).perform
          return render json: {}, status: :unprocessable_entity unless average_service.valid?

          render json: Average.new(average_service.data), status: :ok
        rescue ActiveRecord::RecordNotFound
          render json: {}, status: :unprocessable_entity
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
