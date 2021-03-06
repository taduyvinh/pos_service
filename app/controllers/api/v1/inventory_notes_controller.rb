module Api
  module V1
    class InventoryNotesController < ApplicationController
      before_action :find_inventory_note, only: %i[ show update destroy ]

      def index
        inventory_notes = InventoryNote.all

        json_response message: I18n.t("inventory_notes.load_inventory_notes_success"),
          data: {
            inventory_notes: Serializers::InventoryNoteSerializer.new(object: inventory_notes)
          },
          status: 200
      end

      def show
        json_response message: I18n.t("inventory_notes.load_inventory_note_success"),
          data: {
            inventory_note: Serializers::InventoryNoteSerializer.new(object: inventory_note)
          },
          status: 200
      end

      def create
        inventory_note = InventoryNote.new inventory_note_params
        if inventory_note.save
          created_request_response message: I18n.t("inventory_notes.create_success"),
            data: {
              inventory_note: Serializers::InventoryNoteSerializer.new(object: inventory_note)
            },
            status: 201
        else
          unprocessable_response errors: inventory_note.errors, status: 422
        end
      end

      def update
        if inventory_note.update_attributes inventory_note_params
          json_response message: I18n.t("inventory_notes.update_success"),
            data: {
              inventory_note: Serializers::InventoryNoteSerializer.new(object: inventory_note)
            },
            status: 200
        else
          unprocessable_response errors: inventory_note.errors, status: 422
        end
      end

      def destroy
        inventory_note.destroy
        no_content_response message: I18n.t("inventory_notes.destroy_success"),
          status: 204
      end

      private

      attr_reader :inventory_note

      def inventory_note_params
        params.require(:inventory_note).permit InventoryNote::ATTRIBUTES_PARAMS
      end

      def find_inventory_note
        @inventory_note = inventory_note.find_by id: params[:id]

        return if inventory_note
        not_found_response errors: I18n.t("inventory_notes.not_found_inventory_note"),
          status: :not_found
      end
    end
  end
end
