# frozen_string_literal = true

class Slots::SlotsController < ApplicationController
  before_action :authenticate_user!

  def create
    pp(slot_creation_params, "0000")
    @slot = Slot.new(slot_creation_params)
    if @slot.save!
      render json: {data: @slot}
    else
      render json: {errors: @slot.errors}, status: :unprocessable_entity
    end
  end

  def index
    @slots = Slot.all
  end

  def show
    @slot = Slot.find(params[:id])
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

  def slot_creation_params
    slot_params.merge({user: current_user})
  end

  def slot_params
    params.require(:slot).permit(:code, :name)
  end
end
