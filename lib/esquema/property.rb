# frozen_string_literal: true

require_relative "type_caster"
module Esquema
  # Represents a property in the Esquema schema.
  class Property # rubocop:disable Metrics/ClassLength
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

    NUMERIC_CONSTRAINT_KEYWORDS = %i[minimum maximum exclusiveMinimum exclusiveMaximum multipleOf].freeze
    STRING_CONSTRAINT_KEYWORDS = %i[maxLength minLength pattern format].freeze
    ARRAY_CONSTRAINT_KEYWORDS = %i[maxItems minItems uniqueItems items].freeze
    OBJECT_CONSTRAINT_KEYWORDS = %i[maxProperties minProperties properties additionalProperties dependencies].freeze
    LOGICAL_KEYWORDS = %i[allOf anyOf oneOf not].freeze
    GENERIC_KEYWORDS = %i[type default title description enum const].freeze

    KEYWORDS = (
      NUMERIC_CONSTRAINT_KEYWORDS +
      STRING_CONSTRAINT_KEYWORDS  +
      ARRAY_CONSTRAINT_KEYWORDS   +
      OBJECT_CONSTRAINT_KEYWORDS  +
      LOGICAL_KEYWORDS            +
      GENERIC_KEYWORDS
    ).freeze

    FORMAT_OPTIONS = %i[date-time date time email hostname ipv4 ipv6 uri uuid uri-reference uri-template].freeze

    attr_reader :object, :options

    # Initializes a new Property instance.
    #
    # @param object [Object] The object to build the property for.
    # An object can be any of the following instance types:
    #  An ActiveRecord column. Example: ActiveRecord::ConnectionAdapters::SQLite3::Column
    #  An ActiveRecord association reflection. Example: ActiveRecord::Reflection::BelongsToReflection
    #  An Esquema virtual column. Example: Esquema::VirtualColumn
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
      KEYWORDS.each_with_object({}) do |property, hash|
        value = send("build_#{property.downcase}")
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

    def build_minimum
      options[:minimum]
    end

    def build_maximum
      options[:maximum]
    end

    def build_exclusiveminimum
      options[:exclusiveMinimum]
    end

    def build_exclusivemaximum
      options[:exclusiveMaximum]
    end

    def build_multipleof
      options[:multipleof]
    end

    def build_maxlength
      options[:maxLength]
    end

    def build_minlength
      options[:minLength]
    end

    def build_pattern
      options[:pattern]
    end

    def build_format
      options[:format]
    end

    def build_maxitems
      raise ArgumentError, "maxItems must be an integer" if options[:maxItems] && !options[:maxItems].is_a?(Integer)
      raise ArgumentError, "maxItems must be a non-negative integer" if options[:maxItems] && options[:maxItems] < 0

      if options[:maxItems] && options[:type] != :array
        raise ArgumentError, "maxItems must be use for array type properties only."
      end

      options[:maxItems]
    end

    def build_minitems
      raise ArgumentError, "minItems must be an integer" if options[:minItems] && !options[:minItems].is_a?(Integer)
      raise ArgumentError, "minItems must be a non-negative integer" if options[:minItems] && options[:minItems] < 0

      if options[:minItems] && options[:type] != :array
        raise ArgumentError, "minItems must be use for array type properties only."
      end

      options[:minItems]
    end

    def build_uniqueitems
      options[:uniqueItems]
    end

    def build_properties
      options[:properties]
    end

    def build_maxproperties
      options[:maxProperties]
    end

    def build_minproperties
      options[:minProperties]
    end

    def build_additionalproperties
      options[:additionalProperties]
    end

    def build_dependencies
      options[:dependencies]
    end

    def build_allof
      options[:allOf]
    end

    def build_anyof
      options[:anyOf]
    end

    def build_oneof
      options[:oneOf]
    end

    def build_not
      options[:not]
    end

    def build_const
      options[:const]
    end
  end
end
