# frozen_string_literal: true

module Esquema
  # The KeywordValidator module provides functionality for validating schema keyword values.
  # There are three types of keyword values that must be validated against the type of the
  # property they are associated with:
  # - default: The default value for a property.
  # - enum: The allowed values for a property.
  # - const: The constant value for a property.
  module KeywordValidator
    # The valid options for a property.
    VALID_OPTIONS = %i[type title description maxLength minLength pattern maxItems minItems
                       maxProperties minProperties properties additionalProperties dependencies
                       enum format multipleOf maximum exclusiveMaximum minimum exclusiveMinimum
                       const allOf anyOf oneOf not default items uniqueItems virtual].freeze

    # Hash containing type validators for different data types.
    TYPE_VALIDATORS = {
      string: ->(value) { value.is_a?(String) },
      integer: ->(value) { value.is_a?(Integer) },
      number: ->(value) { value.is_a?(Numeric) },
      boolean: ->(value) { [true, false].include?(value) },
      array: ->(value) { value.is_a?(Array) },
      object: ->(value) { value.is_a?(Hash) },
      null: ->(value) { value.nil? },
      date: ->(value) { value.is_a?(Date) },
      datetime: ->(value) { value.is_a?(DateTime) },
      time: ->(value) { value.is_a?(Time) }
    }.freeze

    # Validates a property based on its type and options.
    #
    # @param property_name [Symbol] The name of the property being validated.
    # @param type [Symbol] The type of the property.
    # @param options [Hash] The options for the property.
    # @option options [Object] :default The default value for the property.
    # @option options [Array] :enum The allowed values for the property.
    # @option options [Object] :const The constant value for the property.
    # @raise [ArgumentError] If the options are not in the VALID_OPTIONS constant.
    # @raise [ArgumentError] If the property name is not a symbol.
    # @raise [ArgumentError] If the property type is not a symbol.
    # @raise [ArgumentError] If the type is unknown.
    def self.validate!(property_name, type, options) # rubocop:disable Metrics/AbcSize
      options.assert_valid_keys(VALID_OPTIONS)
      raise ArgumentError, "Property must be a symbol" unless property_name.is_a?(Symbol)
      raise ArgumentError, "Property type must be a symbol" unless type.is_a?(Symbol)
      raise ArgumentError, "Unknown type #{type}" unless TYPE_VALIDATORS.key?(type)

      validate_default(property_name, type, options[:default]) if options.key?(:default)
      validate_enum(property_name, type, options[:enum]) if options.key?(:enum)
      validate_const(property_name, type, options[:const]) if options.key?(:const)
    end

    # Validates the default value for a property.
    #
    # @param property_name [Symbol] The name of the property being validated.
    # @param type [Symbol] The type of the property.
    # @param default [Object] The default value for the property.
    def self.validate_default(property_name, type, default)
      validate_value!(property_name, type, default, "default")
    end

    # Validates the allowed values for a property.
    #
    # @param property_name [Symbol] The name of the property being validated.
    # @param type [Symbol] The type of the property.
    # @param enum [Array] The allowed values for the property.
    # @raise [ArgumentError] If the enum is not an array.
    def self.validate_enum(property_name, type, enum)
      raise ArgumentError, "Enum for #{property_name} is not an array" unless enum.is_a?(Array)

      enum.each { |value| validate_value!(property_name, type, value, "enum") }
    end

    # Validates the constant value for a property.
    #
    # @param property_name [Symbol] The name of the property being validated.
    # @param type [Symbol] The type of the property.
    # @param const [Object] The constant value for the property.
    def self.validate_const(property_name, type, const)
      validate_value!(property_name, type, const, "const")
    end

    # Validates a value based on its type and keyword.
    #
    # @param property_name [Symbol] The name of the property being validated.
    # @param type [Symbol] The type of the property.
    # @param value [Object] The value to be validated.
    # @param keyword [String] The keyword being validated (e.g., "default", "enum").
    # @raise [ArgumentError] If the value does not match the type.
    def self.validate_value!(property_name, type, value, keyword)
      validator = TYPE_VALIDATORS[type]
      return if validator.call(value)

      raise ArgumentError, "#{keyword.capitalize} value for #{property_name} does not match type #{type}"
    end
  end
end
