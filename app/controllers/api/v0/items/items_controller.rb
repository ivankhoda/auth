# frozen_string_literal=true
module Api
  module V0
    module Items
      class ItemsController < ApplicationController
        before_action :authenticate_user!
        wrap_parameters :slot, include: [:code, :name, :slot_id]

        def create
          @slot = Item.new(item_creation_params)
          if @slot.save
            render json: {slot: @slot}
          else
            render json: {error: @slot.errors.full_messages}, status: :unprocessable_entity
          end
        end

        def index
          @items = current_user_items
          render json: {items: @items}
        end

        def show
          @slot = current_user_items.find(params[:id])
          render json: {slot: @slot}
        end

        def destroy
          @slot = Item.find(params[:id])
          if @slot.destroy
            render status: 204
          else
            render json: {errors: @slot.errors}, status: :unprocessable_entity
          end
        end

        private

        def current_user_items
          current_user.items
        end

        def item_creation_params
          item_params.merge({user: current_user})
        end

        def item_params
          params.require(:slot).permit(:code, :name, :slot_id)
        end
      end
    end
  end
end
