require "active_support/concern"
require_relative "property"

module Esquema
  class Model
    attr_reader :model

    def initialize(model)
      raise ArgumentError, "Class is not an ActiveRecord model" unless model.ancestors.include? ActiveRecord::Base

      @model = model
    end

    def build_schema
      {
        title: model.name.humanize,
        description: nil,
        type: "object",
        properties: build_properties
      }
    end

    def build_properties
      columns.each_with_object({}) do |attr, properties|
        properties[attr.name] = Property.new(attr)
      end
    end

    def columns
      model.columns.reject { |c| excluded_column?(c.name) }
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
