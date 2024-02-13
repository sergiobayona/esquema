module Esquema
  class SchemaEnhancer
    VALID_OPTIONS = %i[title description maxLength minLength pattern maxItems minItems uniqueItems
                       maxProperties minProperties properties additionalProperties dependencies
                       enum format multipleOf maximum exclusiveMaximum minimum exclusiveMinimum
                       const allOf anyOf oneOf not default].freeze

    def initialize(schema_enhancements)
      @schema_enhancements = schema_enhancements
    end

    def model_description(description)
      @schema_enhancements[:model_description] = description
    end

    def model_title(title)
      @schema_enhancements[:model_title] = title
    end

    def property(name, options = {})
      options.assert_valid_keys(VALID_OPTIONS)
      @schema_enhancements[:properties] ||= {}
      @schema_enhancements[:properties][name] = options
    end
  end
end
