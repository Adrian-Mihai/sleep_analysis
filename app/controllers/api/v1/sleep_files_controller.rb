module Api
  module V1
    class SleepFilesController < Api::ApiController
      before_action :check_extension, only: :create

      def index
        render json: user.sleep_files, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: {}, status: :not_found
      end

      def create
        sleep_file = user.sleep_files.create!(filtered_params)
        render json: sleep_file, status: :created
      end

      private

      def user
        return @user if defined? @user

        @user = User.find(params[:user_id])
      end

      def filtered_params
        params.require(:sleep_file).permit(:file)
      end

      def check_extension
        return if filtered_params[:file].content_type.casecmp?(SleepFile::CONTENT_TYPE)

        render json: {}, status: :bad_request
      end
    end
  end
end