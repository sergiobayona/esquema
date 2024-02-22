# frozen_string_literal: true

module Esquema
  class VirtualColumn # rubocop:disable Style/Documentation
    def initialize(property_name, options = {})
      @property_name = property_name
      @options = options
    end

    def name
      @property_name.to_s
    end

    def class_name
      @property_name.to_s.classify
    end

    def type
      @options[:type]
    end

    def item_type
      @options.dig(:items, :type)
    end

    def default
      @options[:default]
    end

    def title
      @options[:title]
    end

    def description
      @options[:description]
    end

    def columns
      []
    end

    def collection?
      @options[:type] == :array
    end
  end
end
