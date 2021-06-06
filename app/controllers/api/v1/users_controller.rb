module Api
  module V1
    class UsersController < Api::ApiController
      def show
        render json: user, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: {}, status: :not_found
      end

      def create
        @user = User.new(filtered_params)
        @user.save!
        render json: @user, status: :created
      rescue ActiveRecord::RecordInvalid
        render json: {}, status: :unprocessable_entity
      end

      def update
        user.update!(filtered_params)
        render json: user, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: {}, status: :not_found
      rescue ActiveRecord::RecordInvalid
        render json: {}, status: :unprocessable_entity
      end

      private

      def filtered_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end

      def user
        return @user if defined? @user

        @user = User.find(params[:id])
      end
    end
  end
end
