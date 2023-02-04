# frozen_string_literal = true

class Item::ItemSerializer < ApplicationSerializer
  def initialize(record, options = {})
    @item = super(record)
    @options = options
    @with_slot = options[:with_slot] == "true"
  end

  def execute
    item.slice(:code, :name, :slot_id, :created_at, :updated_at)
  end

  private

  attr_reader :item, :with_slot

  def slots
    get_slot
  end

  def get_slot
    slots = Slot::CollectionSerializer.new(item.slot).execute
    {slots: slots}
  end
end
