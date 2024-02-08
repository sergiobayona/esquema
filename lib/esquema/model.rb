require "active_support/concern"
require_relative "property"

module Esquema
  class Model
    attr_reader :model
    attr_accessor :metadata

    def initialize(model)
      raise ArgumentError, "Class is not an ActiveRecord model" unless model.ancestors.include? ActiveRecord::Base
      @model = model
      @metadata = {
        title: model.name.humanize,
        description: nil,
        type: "object",
        properties: {}
      }
    end

    def build_schema
      columns.each do |column|
        options = {
          name: column.name,
          type: column.type,
          default: column.default,
          title: column.name.humanize,
          description: nil,
          item_type: nil
        }

        metadata[:properties].merge!(
          column.name.to_sym => Property.new(**options)
        )
      end

      metadata
    end

    def columns
      model.columns.reject {|c| excluded_column?(c.name) }
    end

    def excluded_column?(column_name)
      raise ArgumentError, "Column name must be a string" unless column_name.is_a? String
      Esquema.configuration.excluded_columns.include?(column_name.to_sym)
    end

    def name
      model.name
    end
  end
end
