# frozen_string_literal: true

require "active_support/concern"
require_relative "builder"
require_relative "schema_enhancer"

module Esquema
  # The Esquema module provides functionality for building JSON schemas.
  module Model
    extend ActiveSupport::Concern

    included do
      # Returns the JSON schema for the model.
      def self.json_schema
        Esquema::Builder.new(self).build_schema.to_json
      end

      # Enhances the schema using the provided block.
      def self.enhance_schema(&block)
        schema_enhancements
        enhancer = SchemaEnhancer.new(self, @schema_enhancements)
        enhancer.instance_eval(&block)
      end

      # Returns the schema enhancements.
      def self.schema_enhancements
        @schema_enhancements ||= {}
      end
    end
  end
end
