# frozen_string_literal = true

class Item::ItemSerializer < ApplicationSerializer
  def initialize(record, options={})
    @item = super(record)
    @options = options
    @with_location = options[:with_location] == 'true'
  end

  def execute
  #  todo
  end

  private
  attr_reader :item, :with_items, :with_location



  def slots
    #  todo
    get_slot
  end

  def get_slot
    #  todo
    slots = Slot::CollectionSerializer.new(item.slots).execute
    {slots: slots}
  end
end
