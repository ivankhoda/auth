# frozen_string_literal = true
module Api
  module V0
    module Slots
      class SlotsController < ApplicationController
        before_action :authenticate_user!
        wrap_parameters :slot, include: [:code, :name, :parent_id]

        def create
          @slot = Slot.new(slot_creation_params)
          if @slot.save
            render json: {slot: @slot}
          else
            render json: {error: @slot.errors.full_messages}, status: :unprocessable_entity
          end
        end

        def index
          @slots = current_user_slots
          render json: {slots: @slots}
        end

        def show
          @slot = current_user_slots.find(params[:id])
          render json: {slot: @slot}
        end

        def destroy
          @slot = Slot.find(params[:id])
          if @slot.destroy
            render status: 204
          else
            render json: {errors: @slot.errors}, status: :unprocessable_entity
          end
        end

        private

        def current_user_slots
          current_user.slots
        end

        def slot_creation_params
          slot_params.merge({user: current_user})
        end

        def slot_params
          params.require(:slot).permit(:code, :name, :parent_id)
        end
      end
    end
  end
end
