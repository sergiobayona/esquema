# frozen_string_literal: true

require "date"
require "bigdecimal"
require_relative "keyword_validator"

module Esquema
  # The SchemaEnhancer class is responsible for enhancing the schema of a model.
  class SchemaEnhancer
    attr_reader :model

    def initialize(model, schema_enhancements)
      @schema_enhancements = schema_enhancements
      @model = model
    end

    # Sets the description for the model.
    #
    # @param description [String] The description of the model.
    def model_description(description)
      @schema_enhancements[:model_description] = description
    end

    # Sets the title for the model.
    #
    # @param title [String] The title of the model.
    def model_title(title)
      @schema_enhancements[:model_title] = title
    end

    # Adds a property to the schema.
    #
    # @param name [Symbol] The name of the property.
    # @param options [Hash] Additional options for the property.
    def property(name, options = {})
      validate_property_as_attribute_for(name, options)

      type = resolve_type(name, options)

      KeywordValidator.validate!(name, type, options)

      @schema_enhancements[:properties] ||= {}
      @schema_enhancements[:properties][name] = options
    end

    # Adds a virtual property to the schema.
    #
    # @param name [Symbol] The name of the virtual property.
    # @param options [Hash] Additional options for the virtual property.
    def virtual_property(name, options = {})
      options[:virtual] = true
      property(name, options)
    end

    private

    # Resolves the type of a property.
    #
    # @param name [Symbol] The name of the property.
    # @param options [Hash] Additional options for the property.
    # @return [Symbol] The resolved type of the property.
    def resolve_type(name, options = {})
      if options[:virtual] == true
        options[:type]
      else
        model.type_for_attribute(name).type
      end
    end

    # Retrieves the valid properties for the model.
    #
    # @return [Array<Symbol>] The valid properties for the model.
    def valid_properties
      @valid_properties ||= begin
        properties = model.column_names + model.reflect_on_all_associations.map(&:name)
        properties.map(&:to_sym)
      end
    end

    # Validates that a property is a valid attribute for the model.
    #
    # @param prop_name [Symbol] The name of the property.
    # @param options [Hash] Additional options for the property.
    # @raise [ArgumentError] If the property is not a valid attribute for the model.
    def validate_property_as_attribute_for(prop_name, options = {})
      return if options[:virtual] == true
      raise ArgumentError, "`#{prop_name}` is not a model attribute." unless valid_properties.include?(prop_name.to_sym)
    end
  end
end
