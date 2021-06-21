module Api
  module V1
    class UsersController < Api::V1::AuthenticationController
      before_action :check_user_rights, except: :create
      skip_before_action :authenticate_with_token, only: :create

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

      def same_id?
        @user.id == params[:id].to_i
      end
    end
  end
end
