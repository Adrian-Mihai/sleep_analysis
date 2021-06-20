module Api
  module V1
    class SleepFilesController < Api::ApiController
      before_action :find_user
      before_action :check_extension, only: :create

      def index
        render json: @user.sleep_files, status: :ok
      end

      def create
        sleep_file = @user.sleep_files.create!(filtered_params)
        DelayedServiceCall.perform_later(ParseSleepFile.to_s, { user_id: @user.id, sleep_file_id: sleep_file.id })
        render json: sleep_file, status: :created
      end

      def destroy
        @user.sleep_files.find(params[:id]).destroy!
        render json: {}, status: :ok
      rescue ActiveRecord::RecordNotDestroyed
        render json: {}, status: :unprocessable_entity
      end

      private

      def filtered_params
        params.require(:sleep_file).permit(:file)
      end

      def find_user
        @user = User.find(params[:user_id])
      end

      def check_extension
        return if filtered_params[:file].content_type.casecmp?(SleepFile::CONTENT_TYPE)

        render json: {}, status: :bad_request
      end
    end
  end
end
