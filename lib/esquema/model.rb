# frozen_string_literal: true

require "active_support/concern"
require_relative "property"

module Esquema
  class Model
    attr_reader :model

    def initialize(model)
      raise ArgumentError, "Class is not an ActiveRecord model" unless model.ancestors.include? ActiveRecord::Base

      @model = model
      @properties = {}
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
      add_properties_from_columns
      add_properties_from_has_many_associations
      add_properties_from_has_one_associations

      @properties
    end

    def add_properties_from_columns
      columns.each do |property|
        next if property.name.end_with?("_id") && config.exclude_foreign_keys?

        @properties[property.name] ||= Property.new(property)
      end
    end

    def add_properties_from_has_many_associations
      has_many_associations.each do |association|
        next if config.excluded_models.include?(association.klass.name)

        @properties[association.name] ||= Property.new(association)
      end
    end

    def add_properties_from_has_one_associations
      has_one_associations.each do |association|
        klass = association.klass.name.constantize
        @properties[association.name] ||= self.class.new(klass).build_schema
      end
    end

    def columns
      model.columns.reject { |c| excluded_column?(c.name) }
    end

    def has_many_associations
      model.reflect_on_all_associations(:has_many)
    end

    def has_one_associations
      model.reflect_on_all_associations(:has_one)
    end

    def excluded_column?(column_name)
      raise ArgumentError, "Column name must be a string" unless column_name.is_a? String

      config.excluded_columns.include?(column_name.to_sym)
    end

    def name
      model.name
    end

    def config
      Esquema.configuration
    end
  end
end
