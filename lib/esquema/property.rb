# frozen_string_literal: true

require_relative "type_caster"
module Esquema
  class Property
    DB_TO_JSON_TYPE_MAPPINGS = {
      date: "date",
      datetime: "date-time",
      time: "time",
      string: "string",
      text: "string",
      integer: "integer",
      float: "number",
      decimal: "number",
      boolean: "boolean",
      array: "array",
      object: "object"
    }.freeze

    ATTRS = %i[type default title description items enum].freeze
    attr_accessor(*ATTRS)
    attr_reader :property, :options

    def initialize(property, options = {})
      raise ArgumentError, "property must have a name" unless property.respond_to?(:name)

      @property = property
      @options = options
    end

    def as_json
      ATTRS.each_with_object({}) do |property, hash|
        value = send("build_#{property}")
        next if value.nil? || (value.is_a?(String) && value.empty?)

        hash[property] = value
      end.compact
    end

    def build_title
      options[:title].presence || property.name.to_s.humanize
    end

    def build_default
      return unless property.respond_to?(:default)

      default_value = property.default || options[:default].presence

      @default = TypeCaster.cast(property.type, default_value) unless default_value.nil?
    end

    def build_type
      return DB_TO_JSON_TYPE_MAPPINGS[:array] if property.try(:collection?)

      return unless property.respond_to?(:type)

      @type = DB_TO_JSON_TYPE_MAPPINGS[property.type]
    end

    def build_description
      options[:description]
    end

    def build_items
      return unless property.try(:collection?)

      case property.type
      when :array
        { type: DB_TO_JSON_TYPE_MAPPINGS[property.item_type] }
      else
        Builder.new(property.klass).build_schema
      end
    end

    def build_enum
      options[:enum]
    end
  end
end
