# frozen_string_literal = true

class Slot::SlotSerializer < ApplicationSerializer
  def initialize(record, options = {})
    @slot = super(record)
    @options = options
    @with_items = options[:with_items] == "true"
    @with_child_slots = options[:with_child_slots] == "true"
  end

  def execute
    r = slot.slice(:uuid, :code, :name, :parent_id, :created_at, :updated_at)
    r.merge!(slots) if with_child_slots && children_exists(:slots)
    r.merge!(items) if with_items && children_exists(:items)

    r
  end

  private

  attr_reader :slot, :with_items, :with_child_slots

  def items
    get_items
  end

  def slots
    get_slots
  end

  def get_items
    items = Item::CollectionSerializer.new(slot.items).execute
    { items: items }
  end

  def get_slots
    slots = Slot::CollectionSerializer.new(slot.slots).execute
    {slots: slots}
  end
end
