module Api
  module V1
    class AuthenticationController < Api::ApiController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate_with_token, except: :generate_token

      def generate_token
        @user = User.find_by!(email: authentication_params[:email])
        if @user.authenticate(authentication_params[:password])
          render json: { jwt: JsonWebToken.encode(user: @user) }, status: :created
        else
          render json: { messages: ['Wrong email or password'] }, status: :unauthorized
        end
      rescue ActiveRecord::RecordNotFound
        render json: { messages: ['Wrong email or password'] }, status: :unauthorized
      end

      private

      def authenticate_with_token
        @payload = authenticate_with_http_token { |token, _options| JsonWebToken.decode(token: token) }
        if @payload.present?
          @user = User.find(@payload[:id])
          return
        end

        render json: { messages: ['Access denied'] }, status: :unauthorized
      end

      def authentication_params
        params.require(:authentication).permit(:email, :password)
      end

      def check_user_rights
        return if same_id?

        render json: { messages: ['Access denied'] }, status: :unauthorized
      end

      def same_id?
        @user.id == params[:user_id].to_i
      end
    end
  end
end
