module Esquema
  class Configuration
    attr_accessor :excluded_models, :excluded_columns

    def initialize
      @excluded_columns = []
      @excluded_models = []
    end

    def reset
      @excluded_columns = []
      @excluded_models = []
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
