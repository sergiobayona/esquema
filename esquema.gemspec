# frozen_string_literal: true

require_relative "lib/esquema/version"

Gem::Specification.new do |spec|
  spec.name = "esquema"
  spec.version = Esquema::VERSION
  spec.authors = ["Sergio Bayona"]
  spec.email = ["bayona.sergio@gmail.com"]

  spec.summary = "Generate json-schema from ActiveRecord models."
  spec.description = "Generate json-schema from ActiveRecord models."
  spec.homepage = "https://esquema.co"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://example.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sergiobayona/esquema"
  spec.metadata["changelog_uri"] = "https://github.com/sergiobayona/esquema/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ spec/ .git .github Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "rails", "~> 7.0"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
end
