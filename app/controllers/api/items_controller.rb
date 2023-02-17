# frozen_string_literal = true

module Api
  class ItemsController < ApplicationController
    before_action :authenticate_user!

    def create
      @item = Item.new(item_creation_params)
      if @item.save
        render json: @item
      else
        render json: {error: @item.errors.full_messages}, status: :unprocessable_entity
      end
    end

    def index
      @items = current_user_items.search(params[:code]).paginate(page: params[:page], per_page: params[:per_page])
      render json: @items
    end

    def show
      @item = current_user_items.find(params[:id])
      render json: @item
    end

    def edit
      @item = current_user_items.find_by(id: params[:id])
      if @item.update!(item_update_params)
        render json: Item::ItemSerializer.new(@item).execute
      else
        render json: { error: @item.errors }, status: :unprocessable_entity
      end
    end

    def update
      edit
    end

    def destroy
      @item = Item.find(params[:id])
      if @item.destroy
        render status: 204
      else
        render json: { errors: @item.errors }, status: :unprocessable_entity
      end
    end

    private

    def current_user_items
      current_user.items
    end

    def item_creation_params
      item_params
        .except(:slot_code)
        .merge!({ user: current_user, slot: current_user.slots.find_by(code: params[:slot_code]) })
    end

    def item_update_params
      item_params
        .except(:slot_code)
        .merge!({ slot: current_user.slots.find_by(code: params[:slot_code]) })
    end

    def item_params
      params.permit(:code, :name, :slot_code)
    end
  end
end
