# frozen_string_literal: true

class ApplicationSerializer < ActiveModel::Serializer
  def initialize(record)
    @record = record
  end

  class << self
    def execute
      send(:execute)
    end
  end

  def execute
    raise NotImplementedError
  end

  private
  attr_reader :record, :options

  def children_exists(child)
    record.send(child).present?
  end

  def parent_exists(parent)
    record.send(parent).present?
  end
end
