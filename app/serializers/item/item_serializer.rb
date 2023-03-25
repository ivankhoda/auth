# frozen_string_literal = true

class Item::ItemSerializer < ApplicationSerializer
  def initialize(record, options = {})
    @item = super(record)
    @options = options
    @with_slot = options[:with_slot] == "true"
  end

  def execute
    prepared_slot
  end

  private

  attr_reader :item, :with_slot

  def prepared_slot
    item.slice(:code, :name, :created_at, :updated_at).tap do |i|
      i[:parent_slot] = item.slot.name
    end
  end
end
