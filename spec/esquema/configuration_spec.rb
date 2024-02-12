# frozen_string_literal: true

RSpec.describe Esquema::Configuration do
  # Establish a connection to an in-memory SQLite database
  ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

  # Defines the schema for the 'users' table
  ActiveRecord::Schema.define do
    create_table :users do |t|
      t.string :name
      t.integer :group
      t.date :dob
      t.float :salary
      t.boolean :active, default: false
      t.text :bio
      t.string :country, default: "United States of America"
      t.json :preferences
      t.timestamps
    end

    create_table :tasks do |t|
      t.string :title
      t.integer :user_id
      t.timestamps
    end
  end

  # Define models
  class User < ActiveRecord::Base
    has_many :tasks

    include Esquema::Model
  end

  class Task < ActiveRecord::Base
    belongs_to :user
  end

  after(:each) do
    # Reset configuration to default
    Esquema.configuration.reset
  end

  describe "default settings" do
    it "has a default value for excluded_models" do
      expect(Esquema.configuration.excluded_models).to eq([])
    end

    it "has a default value for excluded_columns" do
      expect(Esquema.configuration.excluded_columns).to eq([])
    end
  end

  describe "reseting" do
    before(:each) do
      Esquema.configure do |config|
        config.excluded_models = ["User"]
        config.excluded_columns = %i[id created_at updated_at deleted_at]
      end
    end

    it "resets the configuration to default" do
      Esquema.configuration.reset
      expect(Esquema.configuration.excluded_models).to eq([])
      expect(Esquema.configuration.excluded_columns).to eq([])
      expect(Esquema.configuration.exclude_foreign_keys).to eq(true)
    end
  end

  describe "exclude a model" do
    before(:each) do
      Esquema.configure do |config|
        config.excluded_models = ["Task"]
      end
    end

    it "does not include the excluded model in the schema" do
      expect(Esquema.configuration.excluded_models).to eq(["Task"])
      expect(User.json_schema).not_to include_json({
                                                     properties: {
                                                       tasks: {
                                                         title: "Tasks"
                                                       }
                                                     }
                                                   })
    end
  end

  describe "exclude columns" do
    before(:each) do
      Esquema.configure do |config|
        config.excluded_columns = %i[id created_at updated_at deleted_at]
      end
    end

    it "allows setting custom values for excluded_columns" do
      expect(Esquema.configuration.excluded_columns).to eq(%i[id created_at updated_at deleted_at])
    end

    it "excludes columns from the schema" do
      expect(Task.json_schema).not_to include_json({
                                                     properties: {
                                                       id: {
                                                         title: "Id"
                                                       },
                                                       created_at: {
                                                         title: "Created at"
                                                       },
                                                       updated_at: {
                                                         title: "Updated at"
                                                       }
                                                     }
                                                   })
    end
  end

  describe "without excluded columns" do
    it "includes all columns in the schema" do
      expect(User.json_schema).to include_json({
                                                 properties: {
                                                   id: {
                                                     title: "Id"
                                                   },
                                                   name: {
                                                     title: "Name"
                                                   },
                                                   group: {
                                                     title: "Group"
                                                   },
                                                   dob: {
                                                     title: "Dob"
                                                   },
                                                   salary: {
                                                     title: "Salary"
                                                   },
                                                   active: {
                                                     title: "Active"
                                                   },
                                                   bio: {
                                                     title: "Bio"
                                                   },
                                                   country: {
                                                     title: "Country"
                                                   },
                                                   preferences: {
                                                     title: "Preferences"
                                                   },
                                                   created_at: {
                                                     title: "Created at"
                                                   },
                                                   updated_at: {
                                                     title: "Updated at"
                                                   }
                                                 }
                                               })
    end
  end

  describe "exclude foreign keys" do
    Esquema.configure do |config|
      config.exclude_foreign_keys = false
    end

    it "allows setting custom values for exclude_foreign_keys" do
      expect(Esquema.configuration.exclude_foreign_keys).to eq(false)
    end

    it "includes foreign keys in the schema" do
      expect(employee_schema).to include_json({
                                                properties: {
                                                  company_id: {
                                                    title: "Company"
                                                  }
                                                }
                                              })
    end
  end

  # describe "including foreign keys" do
  #   it "it includes foreign keys in the schema" do
  #     expect(User.json_schema).not_to include_json({
  #                                                    properties: {
  #                                                      tasks: {
  #                                                        title: "Tasks"
  #                                                      }
  #                                                    }
  #                                                  })
  #   end
  # end
end
