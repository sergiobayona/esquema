# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]
