require "date"
require "bigdecimal"

module Esquema
  class SchemaEnhancer
    VALID_OPTIONS = %i[type title description maxLength minLength pattern maxItems minItems
                       maxProperties minProperties properties additionalProperties dependencies
                       enum format multipleOf maximum exclusiveMaximum minimum exclusiveMinimum
                       const allOf anyOf oneOf not default items uniqueItems virtual].freeze

    TYPE_MAPPINGS = {
      date: Date,
      datetime: DateTime,
      time: Time,
      string: String,
      text: String,
      integer: Integer,
      float: Float,
      decimal: BigDecimal,
      boolean: [TrueClass, FalseClass],
      array: Array,
      object: Object
    }.freeze
    attr_reader :model

    def initialize(model, schema_enhancements)
      @schema_enhancements = schema_enhancements
      @model = model
    end

    def model_description(description)
      @schema_enhancements[:model_description] = description
    end

    def model_title(title)
      @schema_enhancements[:model_title] = title
    end

    def property(name, options = {})
      options.assert_valid_keys(VALID_OPTIONS)
      validate_property_for(name, options)
      db_type = model.type_for_attribute(name).type
      klass_type = Array(TYPE_MAPPINGS[db_type])

      validate_default_value(options[:default], klass_type, db_type)
      validate_enum_values(options[:enum], klass_type, db_type)

      @schema_enhancements[:properties] ||= {}
      @schema_enhancements[:properties][name] = options
    end

    def virtual_property(name, options = {})
      options[:virtual] = true
      property(name, options)
    end

    def valid_properties
      @valid_properties ||= begin
        properties = model.column_names + model.reflect_on_all_associations.map(&:name)
        properties.map(&:to_sym)
      end
    end

    private

    def validate_property_for(prop_name, options = {})
      return if options[:virtual] == true
      raise ArgumentError, "`#{prop_name}` is not a valid property." unless valid_properties.include?(prop_name.to_sym)
    end

    def validate_default_value(default_value, klass_type, db_type)
      return unless default_value.present? && !klass_type.include?(default_value.class)

      raise ArgumentError, "Default value must be of type #{db_type}"
    end

    def validate_enum_values(enum_values, klass_type, db_type)
      return unless enum_values.present? && !enum_values.all? { |value| klass_type.include?(value.class) }

      raise ArgumentError, "Enum values must be of type #{db_type}"
    end
  end
end
