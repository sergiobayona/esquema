require_relative 'type_caster'
module Esquema
  class Property
    TYPE_MAPPINGS = {
      date: 'date',
      datetime: 'date-time',
      time: 'time',
      string: 'string',
      integer: 'integer',
      float: 'number',
      decimal: 'number',
      boolean: 'boolean',
      array: 'array'
    }.freeze

    ATTRS = %i[type default title description item_type].freeze
    attr_accessor(*ATTRS)
    attr_reader :column

    def initialize(column)
      raise ArgumentError, 'object must have a type' unless column.respond_to?(:type)
      raise ArgumentError, 'column must have a name' unless column.respond_to?(:name)

      @column = column
    end

    def valid_string?(string)
      string.is_a?(String) && !string.empty?
    end

    def as_json
      ATTRS.each_with_object({}) do |column, hash|
        value = send("build_#{column}")
        next if value.nil? || (value.is_a?(String) && value.empty?)

        hash[column] = value
      end.compact
    end

    def build_title
      return unless valid_string?(column.name)

      column.name.humanize
    end

    def build_default
      @default = TypeCaster.cast(column.type, column.default) unless column.default.nil?
    end

    def build_type
      @type = TYPE_MAPPINGS[column.type]
    end

    def build_item_type
      return unless column.respond_to?(:item_type)

      @item_type = column.item_type if column.type == :array
    end

    def build_description; end
  end
end
