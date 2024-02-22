# frozen_string_literal: true

module Esquema
  module TypeCaster # rubocop:disable Style/Documentation
    def self.cast(type, value) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
      case type
      when :string, :text
        value.to_s
      when :integer
        begin
          Integer(value)
        rescue StandardError
          nil
        end
      when :float
        begin
          Float(value)
        rescue StandardError
          nil
        end
      when :number
        if value.to_s.include?(".")
          begin
            Float(value)
          rescue StandardError
            nil
          end
        else
          begin
            Integer(value)
          rescue StandardError
            nil
          end
        end
      when :boolean
        case value
        when true, "true", "1", 1
          true
        when false, "false", "0", 0
          false
        end
      when :array
        Array(value)
      when :object
        value.is_a?(Hash) ? value : nil # or convert as desired
      when :null
        nil if value.nil?
      else
        raise ArgumentError, "Unsupported type: #{type}"
      end
    end
  end
end
