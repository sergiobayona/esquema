require "active_support/concern"
require_relative "model"

module Esquema
  class Serializer
    def initialize(model)
      raise ArgumentError, "Class is not an ActiveRecord model" unless model.ancestors.include? ActiveRecord::Base

      @model = model
    end

    def serialize
      Model.new(@model).build_schema.to_json
    end
  end
end
