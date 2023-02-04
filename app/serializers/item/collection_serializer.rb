# frozen_string_literal = true

class Item::CollectionSerializer < ApplicationSerializer
  def initialize(records)
    @items = super(records)
  end

  def execute
    serialized_items
  end

  private

  attr_reader :items

  def serialized_items
    items.map { |i| Item::ItemSerializer.new(i).execute }
  end
end
