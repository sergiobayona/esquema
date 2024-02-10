# frozen_string_literal: true

require "rails/generators"

module Esquema
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_initializer_file
        template "esquema_initializer.rb", "config/initializers/esquema.rb"
      end

      def add_rspec
        # Add specific actions here, like copying files, adding lines to files, etc.
        # For example, to add RSpec to the Gemfile:
        gem_group :development, :test do
          gem "rspec-rails", "~> x.x.x"
        end
        # Don't forget to run bundle install if you modify the Gemfile
      end

      private

      def gem_group(*names)
        append_to_file "Gemfile", "\n\ngroup #{names.map(&:inspect).join(", ")} do\n", verbose: true
        yield if block_given?
        append_to_file "Gemfile", "end\n", verbose: true
      end
    end
  end
end
