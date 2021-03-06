module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :find_category, only: %i[ show update destroy ]

      def index
        categories = Category.all

        json_response message: I18n.t("categories.load_categories_success"),
          data: {
            categories: Serializers::CategorySerializer.new(object: categories)
          },
          status: 200
      end

      def show
        json_response message: I18n.t("categories.load_category_success"),
          data: {
            category: Serializers::CategorySerializer.new(object: category)
          },
          status: 200
      end

      def create
        category = Category.new category_params
        if category.save
          created_request_response message: I18n.t("categories.create_success"),
            data: {
              category: Serializers::CategorySerializer.new(object: category)
            },
            status: 201
        else
          unprocessable_response errors: category.errors, status: 422
        end
      end

      def update
        if category.update_attributes category_params
          json_response message: I18n.t("categories.update_success"),
            data: {
              category: Serializers::CategorySerializer.new(object: category)
            },
            status: 200
        else
          unprocessable_response errors: category.errors, status: 422
        end
      end

      def destroy
        category.destroy
        no_content_response message: I18n.t("categories.destroy_success"),
          status: 204
      end

      private

      attr_reader :category

      def category_params
        params.require(:category).permit Category::ATTRIBUTES_PARAMS
      end

      def find_category
        @category = Category.find_by id: params[:id]

        return if category
        not_found_response errors: I18n.t("categories.not_found_category"), status: 404
      end
    end
  end
end
