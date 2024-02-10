# frozen_string_literal: true

require_relative "type_caster"
module Esquema
  class Property
    TYPE_MAPPINGS = {
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

    ATTRS = %i[type default title description item_type items enum].freeze
    attr_accessor(*ATTRS)
    attr_reader :property

    def initialize(property)
      raise ArgumentError, "property must have a name" unless property.respond_to?(:name)

      @property = property
    end

    def valid_string?(string)
      string.is_a?(String) && !string.empty?
    end

    def as_json
      ATTRS.each_with_object({}) do |property, hash|
        value = send("build_#{property}")
        next if value.nil? || (value.is_a?(String) && value.empty?)

        hash[property] = value
      end.compact
    end

    def build_title
      property.name.to_s.humanize
    end

    def build_default
      return unless property.respond_to?(:default)

      @default = TypeCaster.cast(property.type, property.default) unless property.default.nil?
    end

    def build_type
      return TYPE_MAPPINGS[:array] if property.try(:collection?)

      @type = TYPE_MAPPINGS[property.type]
    end

    def build_item_type
      return unless property.respond_to?(:item_type)

      @item_type = property.item_type if property.type == :array
    end

    def build_description; end

    def build_items
      return unless property.try(:collection?)

      class_name = property.class_name.constantize
      @items = Model.new(class_name).build_schema
    end

    def build_enum; end
  end
end
