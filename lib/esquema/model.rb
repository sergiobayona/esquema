# frozen_string_literal: true

require "active_support/concern"
require_relative "builder"

module Esquema
  module Model
    extend ActiveSupport::Concern

    included do
      def self.json_schema
        Esquema::Builder.new(self).build_schema.to_json
      end
    end
  end
end
