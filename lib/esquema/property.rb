# frozen_string_literal: true

require_relative "type_caster"
module Esquema
  # Represents a property in the Esquema schema.
  class Property
    # Mapping of database types to JSON types.
    DB_TO_JSON_TYPE_MAPPINGS = {
      date: "date",
      datetime: "date-time",
      time: "time",
      string: "string",
      text: "string",
      integer: "integer",
      float: "number",
      number: "number",
      decimal: "number",
      boolean: "boolean",
      array: "array",
      object: "object"
    }.freeze

    # List of attribute names for the Property class.
    ATTRS = %i[type default title description items enum].freeze

    # Accessors for the attributes.
    attr_accessor(*ATTRS)
    attr_reader :object, :options

    # Initializes a new Property instance.
    #
    # @param object [Object] The object to build the property for.
    # An object can be any of the following instance types:
    #  An ActiveRecord column. Example: ActiveRecord::ConnectionAdapters::SQLite3::Column
    #  An ActiveRecord association reflection. Example: ActiveRecord::Reflection::BelongsToReflection
    #  A virtual property.
    # @param options [Hash] Additional options for the property.
    # @raise [ArgumentError] If the property does not have a name.
    def initialize(object, options = {})
      raise ArgumentError, "property must have a name" unless object.respond_to?(:name)

      @object = object
      @options = options
    end

    # Converts the Property instance to a JSON representation.
    #
    # @return [Hash] The JSON representation of the Property.
    def as_json
      ATTRS.each_with_object({}) do |property, hash|
        value = send("build_#{property}")
        next if value.nil? || (value.is_a?(String) && value.empty?)

        hash[property] = value
      end.compact
    end

    # Builds the title attribute for the Property.
    #
    # @return [String] The title attribute.
    def build_title
      options[:title].presence || object.name.to_s.humanize
    end

    # Builds the default attribute for the Property.
    #
    # @return [Object, nil] The default attribute.
    def build_default
      return unless object.respond_to?(:default)

      default_value = object.default || options[:default].presence

      @default = TypeCaster.cast(object.type, default_value) unless default_value.nil?
    end

    # Builds the type attribute for the Property.
    #
    # @return [String, nil] The type attribute.
    def build_type
      return DB_TO_JSON_TYPE_MAPPINGS[:array] if object.try(:collection?)

      return unless object.respond_to?(:type)

      @type = DB_TO_JSON_TYPE_MAPPINGS[object.type]
    end

    # Builds the description attribute for the Property.
    #
    # @return [String, nil] The description attribute.
    def build_description
      options[:description]
    end

    # Builds the items attribute for the Property.
    #
    # @return [Hash, nil] The items attribute.
    def build_items
      return unless object.try(:collection?)

      case object.type
      when :array
        { type: DB_TO_JSON_TYPE_MAPPINGS[object.item_type] }
      else
        Builder.new(object.klass).build_schema
      end
    end

    # Builds the enum attribute for the Property.
    #
    # @return [Array, nil] The enum attribute.
    def build_enum
      options[:enum]
    end
  end
end
