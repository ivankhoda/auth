# frozen_string_literal = true

module Api
  class SlotsController < ApplicationController
    before_action :authenticate_user!

    def create
      @slot = Slot.new(slot_creation_params)
      if @slot.save
        render json: @slot
      else
        render json: {error: @slot.errors.full_messages}, status: :unprocessable_entity
      end
    end

    def index
      @slots = current_user_slots
      render json: @slots
    end


    def show
      @slot = current_user_slots.find_by(uuid: params[:id])
      render json: Slot::SlotSerializer.new(@slot, slot_params).execute
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

    def options
      slot_params.to_h
    end

    def current_user_slots
      current_user.slots
    end

    def slot_creation_params
      slot_params.merge({user: current_user})
    end

    def slot_params
      params.permit(:id, :code, :name, :parent_id, :with_items, :with_child_slots)
    end
  end
end
