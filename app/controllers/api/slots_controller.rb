# frozen_string_literal = true

module Api
  class SlotsController < ApplicationController
    before_action :authenticate_user!

    def create
      @slot = Slot.new(slot_creation_params)
      if @slot.save
        render json: Slot::SlotSerializer.new(@slot).execute
      else
        render json: {error: @slot.errors.full_messages}, status: :unprocessable_entity
      end
    end

    def index
      @slots = current_user_slots.search(params[:code]).paginate(page: params[:page], per_page: params[:per_page])
      render json: Slot::CollectionSerializer.new(@slots).execute
    end

    def show
      @slot = current_user_slots.find_by(uuid: params[:id])
      render json: Slot::SlotSerializer.new(@slot, slot_params).execute
    end

    def edit
      @slot = current_user_slots.find_by(uuid: params[:id])
      if @slot.update!(slot_update_params)
        render json: Slot::SlotSerializer.new(@slot).execute
      else
        render json: { error: @slot.errors }, status: :unprocessable_entity
      end
    end

    def update
      edit
    end

    def destroy
      @slot = Slot.find(params[:id])
      if @slot.destroy
        render status: 204
      else
        render json: { errors: @slot.errors }, status: :unprocessable_entity
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
      slot_params.merge({ user: current_user })
    end

    def slot_update_params
      params.permit(:code, :name, :parent_id)
    end

    def slot_params
      params.permit(:id, :code, :name, :parent_id, :with_items, :with_child_slots)
    end
  end
end
