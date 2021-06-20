module Api
  module V1
    class UsersController < Api::ApiController
      before_action :find_user, only: %i[show update]

      def show
        render json: @user, status: :ok
      end

      def create
        @user = User.new(filtered_params)
        @user.save!
        render json: @user, status: :created
      end

      def update
        @user.update!(filtered_params)
        render json: @user, status: :ok
      end

      private

      def filtered_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end

      def find_user
        @user = User.find(params[:id])
      end
    end
  end
end
