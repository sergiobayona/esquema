# frozen_string_literal: true

require_relative "property"

module Esquema
  class Builder
    attr_reader :model, :required_properties

    def initialize(model)
      raise ArgumentError, "Class is not an ActiveRecord model" unless model.ancestors.include? ActiveRecord::Base

      @model = model
      @properties = {}
      @required_properties = []
    end

    def build_schema
      schema = {
        title: build_title,
        description: build_description,
        type: "object",
        properties: build_properties,
        required: required_properties
      }

      schema.compact
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

        required_properties << property.name
        options = enhancement_for(property.name)
        @properties[property.name] ||= Property.new(property, options)
      end
    end

    def add_properties_from_has_many_associations
      has_many_associations.each do |association|
        next if config.exclude_associations?

        @properties[association.name] ||= Property.new(association)
      end
    end

    def add_properties_from_has_one_associations
      has_one_associations.each do |association|
        next if config.exclude_associations?

        klass = association.klass.name.constantize
        @properties[association.name] ||= self.class.new(klass).build_schema
      end
    end

    def columns
      model.columns.reject { |c| excluded_column?(c.name) }
    end

    def enhancement_for(property_name)
      schema_enhancements&.dig(:properties, property_name.to_sym) || {}
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

    def build_title
      schema_enhancements[:model_title].presence || model.name.demodulize.humanize
    end

    def build_description
      schema_enhancements[:model_description].presence
    end

    def name
      model.name
    end

    def schema_enhancements
      if model.respond_to?(:schema_enhancements)
        model.schema_enhancements
      else
        {}
      end
    end

    def config
      Esquema.configuration
    end
  end
end
