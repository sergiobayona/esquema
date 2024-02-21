# frozen_string_literal: true

require_relative "property"

module Esquema
  # The Builder class is responsible for building a schema for an ActiveRecord model.
  class Builder
    attr_reader :model, :required_properties

    def initialize(model)
      raise ArgumentError, "Class is not an ActiveRecord model" unless model.ancestors.include? ActiveRecord::Base

      @model = model
      @properties = {}
      @required_properties = []
    end

    # Builds the schema for the ActiveRecord model.
    #
    # @return [Hash] The built schema.
    def build_schema
      @build_schema ||= {
        title: build_title,
        description: build_description,
        type: build_type,
        properties: build_properties,
        required: required_properties
      }.compact
    end

    # @return [Hash] The schema for the ActiveRecord model.
    def schema
      build_schema
    end

    # Builds the properties for the schema.
    #
    # @return [Hash] The built properties.
    def build_properties
      add_properties_from_columns
      add_properties_from_associations
      add_virtual_properties
      @properties
    end

    # Builds the type for the schema.
    #
    # @return [String] The built type.
    def build_type
      model.respond_to?(:type) ? model.type : "object"
    end

    private

    # Adds virtual properties to the schema.
    def add_virtual_properties
      return unless schema_enhancements[:properties]

      virtual_properties = schema_enhancements[:properties].select { |_k, v| v[:virtual] }
      required_properties.concat(virtual_properties.keys)

      virtual_properties.each do |property_name, options|
        virtual_prop = create_virtual_prop(property_name, options)
        @properties[property_name] = Property.new(virtual_prop, options)
      end
    end

    # Creates a virtual property.
    #
    # @param property_name [Symbol] The name of the property.
    # @param options [Hash] The options for the property.
    # @return [OpenStruct] The created virtual property.
    def create_virtual_prop(property_name, options)
      OpenStruct.new(name: property_name.to_s,
                     class_name: property_name.to_s.classify,
                     type: options[:type],
                     item_type: options.dig(:items, :type),
                     default: options[:default],
                     title: options[:title],
                     description: options[:description],
                     enum: options[:enum],
                     columns: [],
                     collection?: options[:type] == :array)
    end

    # Adds properties from columns to the schema.
    def add_properties_from_columns
      columns.each do |property|
        next if property.name.end_with?("_id") && config.exclude_foreign_keys?

        required_properties << property.name
        options = enhancement_for(property.name)
        @properties[property.name] ||= Property.new(property, options)
      end
    end

    # Adds properties from associations to the schema.
    def add_properties_from_associations
      associations.each do |association|
        next if config.exclude_associations?

        @properties[association.name] ||= Property.new(association)
      end
    end

    # Retrieves the columns of the model.
    #
    # @return [Array<ActiveRecord::ConnectionAdapters::Column>] The columns of the model.
    def columns
      model.columns.reject { |c| excluded_column?(c.name) }
    end

    # Retrieves the enhancement options for a property.
    #
    # @param property_name [Symbol] The name of the property.
    # @return [Hash] The enhancement options for the property.
    def enhancement_for(property_name)
      schema_enhancements.dig(:properties, property_name.to_sym) || {}
    end

    # Retrieves the associations of the model.
    #
    # @return [Array<ActiveRecord::Reflection::AssociationReflection>] The associations of the model.
    def associations
      return [] unless model.respond_to?(:reflect_on_all_associations)

      model.reflect_on_all_associations
    end

    # Checks if a column is excluded.
    #
    # @param column_name [String] The name of the column.
    # @return [Boolean] True if the column is excluded, false otherwise.
    def excluded_column?(column_name)
      raise ArgumentError, "Column name must be a string" unless column_name.is_a? String

      config.excluded_columns.include?(column_name.to_sym)
    end

    # Builds the title for the schema.
    #
    # @return [String] The built title.
    def build_title
      schema_enhancements[:model_title].presence || model.name.demodulize.humanize
    end

    # Builds the description for the schema.
    #
    # @return [String] The built description.
    def build_description
      schema_enhancements[:model_description].presence
    end

    # Retrieves the schema enhancements for the model.
    #
    # @return [Hash] The schema enhancements.
    def schema_enhancements
      if model.respond_to?(:schema_enhancements)
        model.schema_enhancements
      else
        {}
      end
    end

    # Retrieves the Esquema configuration.
    #
    # @return [Esquema::Configuration] The Esquema configuration.
    def config
      Esquema.configuration
    end
  end
end
