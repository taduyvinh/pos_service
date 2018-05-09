module Api
  module V1
    class ProvidersController < ApplicationController
      before_action :find_provider, only: %i[ show update destroy ]

      def index
        providers = Provider.all

        json_response json: {
          message: I18n.t("providers.load_providers_success"),
          data: {
            providers: providers
          },
          status: 200
        }
      end

      def show
        json_response json: {
          message: I18n.t("providers.load_provider_success"),
          data: {
            provider: provider
          },
          status: 200
        }
      end

      def create
        provider = Provider.new provider_params
        if provider.save
          created_request_response json: {
            message: I18n.t("providers.create_success"),
            data: {
              provider: provider
            },
            status: 201
          }
        else
          unprocessable_response json: { errors: provider.errors, status: 422 }
        end
      end

      def update
        if provider.update_attributes provider_params
          json_response json: {
            message: I18n.t("providers.update_success"),
            data: {
              provider: provider
            },
            status: 200
          }
        else
          unprocessable_response json: {
            errors: provider.errors, status: 422
          }
        end
      end

      def destroy
        provider.destroy
        no_content_response json: {message: I18n.t("providers.destroy_success")},
          status: :no_content
      end

      private

      attr_reader :provider

      def provider_params
        params.require(:provider).permit Provider::ATTRIBUTES_PARAMS
      end

      def find_provider
        @provider = provider.find_by id: params[:id]

        return if provider
        not_found_response json: {
          errors: I18n.t("providers.not_found_provider")
        }, status: :not_found
      end
    end
  end
end
