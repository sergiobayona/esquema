# frozen_string_literal: true

require "active_support/concern"
require_relative "builder"
require_relative "schema_enhancer"

module Esquema
  module Model
    extend ActiveSupport::Concern

    included do
      def self.json_schema
        Esquema::Builder.new(self).build_schema.to_json
      end

      def self.enhance_schema(&block)
        schema_enhancements
        enhancer = SchemaEnhancer.new(self, @schema_enhancements)
        enhancer.instance_eval(&block)
      end

      def self.schema_enhancements
        @schema_enhancements ||= {}
      end
    end
  end
end
