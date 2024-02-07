module Esquema
  # This class is responsible for analyzing the ActiveRecord models and generating
  # the json-schema representation of them.
  class Analyzer
    # This method is responsible for analyzing the ActiveRecord models and generating
    # the json-schema representation of them.
    def self.analyze
      Rails.application.eager_load!
      ActiveRecord::Base.descendants.each do |model|
        puts model.name
      end
    end
  end
end
