# frozen_string_literal: true

require_relative "property"

module Esquema
  class Builder
    attr_reader :model, :required_properties, :schema

    def initialize(model)
      raise ArgumentError, "Class is not an ActiveRecord model" unless model.ancestors.include? ActiveRecord::Base

      @model = model
      @properties = {}
      @required_properties = []
    end

    def build_schema
      @schema ||= {
        title: build_title,
        description: build_description,
        type: build_type,
        properties: build_properties,
        required: required_properties
      }.compact
    end

    def build_properties
      add_properties_from_columns
      add_properties_from_associations
      add_virtual_properties
      @properties
    end

    def build_type
      model.respond_to?(:type) ? model.type : "object"
    end

    def add_virtual_properties
      return unless schema_enhancements[:properties]

      virtual_properties = schema_enhancements[:properties].select { |_k, v| v[:virtual] }
      required_properties.concat(virtual_properties.keys)

      virtual_properties.each do |property_name, options|
        virtual_prop = create_virtual_prop(property_name, options)
        @properties[property_name] = Property.new(virtual_prop, options)
      end
    end

    def create_virtual_prop(property_name, options)
      OpenStruct.new(name: property_name.to_s,
                     class_name: property_name.to_s.classify,
                     type: options[:type],
                     item_type: options[:items][:type],
                     default: options[:default],
                     title: options[:title],
                     description: options[:description],
                     enum: options[:enum],
                     columns: [],
                     collection?: options[:type] == :array)
    end

    def add_properties_from_columns
      columns.each do |property|
        next if property.name.end_with?("_id") && config.exclude_foreign_keys?

        required_properties << property.name
        options = enhancement_for(property.name)
        @properties[property.name] ||= Property.new(property, options)
      end
    end

    def add_properties_from_associations
      associations.each do |association|
        next if config.exclude_associations?

        @properties[association.name] ||= Property.new(association)
      end
    end

    def columns
      model.columns.reject { |c| excluded_column?(c.name) }
    end

    def enhancement_for(property_name)
      schema_enhancements.dig(:properties, property_name.to_sym) || {}
    end

    def associations
      return [] unless model.respond_to?(:reflect_on_all_associations)

      model.reflect_on_all_associations
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
