require "active_support/concern"
require_relative "property"

module Esquema
  class Model
    attr_reader :model
    attr_accessor :metadata

    def initialize(model)
      raise ArgumentError, "Class is not an ActiveRecord model" unless model.ancestors.include? ActiveRecord::Base
      @model = model
      @metadata = {}
    end

    def build_schema
      model.columns.each do |column|
        options = {
          name: column.name,
          type: column.type,
          default: column.default,
          title: column.name.humanize,
          description: nil,
          item_type: nil
        }

        metadata.merge!(
          column.name.to_sym => Property.new(**options)
        )
      end

      metadata
    end

    def name
      model.name
    end
  end
end
