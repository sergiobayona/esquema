# frozen_string_literal: true

require "rake"
require "esquema"
require "pry-byebug"
require "active_record"

Dir[File.expand_path("spec/support/**/*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Tasks::DatabaseTasks.drop_all
    ActiveRecord::Schema.define do
      create_table :tasks do |t|
        t.string :title
        t.integer :user_id
        t.timestamps
      end

      create_table :users do |t|
        t.string :name
        t.string :email
        t.integer :group
        t.date :dob
        t.float :salary
        t.boolean :active, default: false
        t.text :bio
        t.string :country, default: "United States of America"
        t.json :preferences
        t.timestamps
      end
    end
  end
end
