# frozen_string_literal: true

module Esquema
  module TypeCaster
    def self.cast(type, value) # rubocop:disable Metrics/MethodLength
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
      when :boolean
        case value
        when true, "true", "1", 1
          true
        when false, "false", "0", 0
          false
        else
          nil # or handle as desired
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
