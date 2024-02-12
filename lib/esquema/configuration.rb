# frozen_string_literal: true

module Esquema
  class Configuration
    attr_accessor :excluded_models, :excluded_columns, :exclude_foreign_keys

    def initialize
      reset
    end

    def reset
      @excluded_columns = []
      @excluded_models = []
      @exclude_foreign_keys = true
    end

    def exclude_foreign_keys?
      exclude_foreign_keys
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
