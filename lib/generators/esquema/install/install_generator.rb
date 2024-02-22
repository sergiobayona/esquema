# frozen_string_literal: true

require "rails/generators"

module Esquema
  module Generators
    # This generator is responsible for installing the Esquema gem.
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_initializer_file
        template "esquema_initializer.rb", "config/initializers/esquema.rb"
      end
    end
  end
end
