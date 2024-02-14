# frozen_string_literal: true

require "spec_helper"

module Conf
  class Task < ActiveRecord::Base
    include Esquema::Model
    belongs_to :user, class_name: "Conf::User"
  end

  class User < ActiveRecord::Base
    include Esquema::Model
    has_many :tasks, class_name: "Conf::Task"
  end
end

RSpec.describe Esquema::Configuration do
  after(:each) do
    # Reset configuration to default
    Esquema.configuration.reset
  end

  describe "default settings" do
    it "defaults to false for exclude_associations" do
      expect(Esquema.configuration.exclude_associations).to eq(false)
    end

    it "defaults to true for exclude_foreign_keys" do
      expect(Esquema.configuration.exclude_foreign_keys).to eq(true)
    end

    it "is empty for excluded_columns" do
      expect(Esquema.configuration.excluded_columns).to eq([])
    end
  end

  describe "reseting" do
    before(:each) do
      Esquema.configure do |config|
        config.exclude_associations = true
        config.excluded_columns = %i[id created_at updated_at deleted_at]
      end
    end

    it "resets the configuration to default" do
      Esquema.configuration.reset
      expect(Esquema.configuration.excluded_columns).to eq([])
      expect(Esquema.configuration.exclude_associations).to eq(false)
      expect(Esquema.configuration.exclude_foreign_keys).to eq(true)
    end
  end

  describe "exclude associations" do
    before(:each) do
      Esquema.configure do |config|
        config.exclude_associations = true
      end
    end

    it "does not include the excluded model in the schema" do
      expect(Esquema.configuration.exclude_associations).to eq(true)
      expect(Conf::User.json_schema).not_to include_json({
                                                           properties: {
                                                             tasks: {
                                                               title: "Tasks"
                                                             }
                                                           }
                                                         })
    end
  end

  describe "include associations" do
    before(:each) do
      Esquema.configure do |config|
        config.exclude_associations = false
      end
    end

    it "does not include the excluded model in the schema" do
      expect(Esquema.configuration.exclude_associations).to eq(false)
      expect(Conf::User.json_schema).to include_json({
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
      expect(Conf::Task.json_schema).not_to include_json({
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
      expect(Conf::User.json_schema).to include_json({
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

  describe "include foreign keys" do
    before do
      Esquema.configure do |config|
        config.exclude_foreign_keys = false
      end
    end

    it "allows setting custom values for exclude_foreign_keys" do
      expect(Esquema.configuration.exclude_foreign_keys).to eq(false)
    end

    it "includes foreign keys in the schema" do
      expect(Conf::Task.json_schema).to include_json({
                                                       properties: {
                                                         user_id: {
                                                           title: "User"
                                                         }
                                                       }
                                                     })
    end
  end
end
