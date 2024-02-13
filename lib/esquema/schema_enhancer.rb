require "date"
require "bigdecimal"

module Esquema
  class SchemaEnhancer
    VALID_OPTIONS = %i[title description maxLength minLength pattern maxItems minItems uniqueItems
                       maxProperties minProperties properties additionalProperties dependencies
                       enum format multipleOf maximum exclusiveMaximum minimum exclusiveMinimum
                       const allOf anyOf oneOf not default].freeze

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
      db_type = model.type_for_attribute(name).type
      klass_type = Array(TYPE_MAPPINGS[db_type])

      validate_default_value(options[:default], klass_type, db_type)
      validate_enum_values(options[:enum], klass_type, db_type)

      options.assert_valid_keys(VALID_OPTIONS)
      @schema_enhancements[:properties] ||= {}
      @schema_enhancements[:properties][name] = options
    end

    private

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
