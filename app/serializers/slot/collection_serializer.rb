# frozen_string_literal = true

class Slot::CollectionSerializer < ApplicationSerializer
  def initialize(records)
    @slots = super(records)
  end

  def execute
    serialized_slots
  end

  private
  attr_reader :slots

  def serialized_slots
     slots.map { |s| Slot::SlotSerializer.new(s).execute }
  end

end
