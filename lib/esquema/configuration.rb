# frozen_string_literal: true

module Esquema # rubocop:disable Style/Documentation
  # The Configuration module provides configuration options for the gem.
  class Configuration
    attr_accessor :exclude_associations, :exclude_foreign_keys, :excluded_columns

    def initialize
      reset
    end

    def reset
      @exclude_associations = false
      @exclude_foreign_keys = true
      @excluded_columns = []
    end

    def exclude_foreign_keys?
      exclude_foreign_keys
    end

    def exclude_associations?
      exclude_associations
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
