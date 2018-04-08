module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = User.all
        json_response response: {
          message: I18n.t("users.load_users_success"),
          data: {
            users: Serializers::UserSerializer.new(object: users)
          },
          status: 200
        }

      end

      def create
        user = User.new user_params
        if user.save
          created_request_response response: {
            message: I18n.t("users.create_success"),
            data: Serializers::UserSerializer.new(object: user),
            status: 201
          }
        else
          render json: {
            errors: user.errors, status: 422
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit User::ATTRIBUTES_PARAMS
      end
    end
  end
end
