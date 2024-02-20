# frozen_string_literal: true

require "date"
require "bigdecimal"
require_relative "keyword_validator"

module Esquema
  class SchemaEnhancer
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
      validate_property_as_attribute_for(name, options)

      type = resolve_type(name, options)

      KeywordValidator.validate!(name, type, options)

      @schema_enhancements[:properties] ||= {}
      @schema_enhancements[:properties][name] = options
    end

    def virtual_property(name, options = {})
      options[:virtual] = true
      property(name, options)
    end

    def resolve_type(name, options = {})
      if options[:virtual] == true
        options[:type]
      else
        model.type_for_attribute(name).type
      end
    end

    def valid_properties
      @valid_properties ||= begin
        properties = model.column_names + model.reflect_on_all_associations.map(&:name)
        properties.map(&:to_sym)
      end
    end

    private

    def validate_property_as_attribute_for(prop_name, options = {})
      return if options[:virtual] == true
      raise ArgumentError, "`#{prop_name}` is not a model attribute." unless valid_properties.include?(prop_name.to_sym)
    end
  end
end
