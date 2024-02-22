# frozen_string_literal: true

require "spec_helper"

RSpec.describe Esquema::Model do
  user = Class.new(ActiveRecord::Base) do
    include Esquema::Model
    self.table_name = "users"

    def self.name
      "User"
    end
  end

  after { Esquema.configuration.reset }

  describe ".schema_enhancements" do
    it "returns the schema enhancements" do
      expect(user.schema_enhancements).to eq({})
    end
  end

  describe ".enhance_schema" do
    it "enhances the schema using the provided block" do
      user.enhance_schema do
        property :name, title: "Person's Name"
        property :email, title: "Person's Mailing Address"
      end

      expect(user.schema_enhancements).to eq(
        properties: {
          name: { title: "Person's Name" },
          email: { title: "Person's Mailing Address" }
        }
      )
    end
  end

  it "returns a ruby hash representing the schema_model properties" do
    expect(user.json_schema).to include_json({
                                               "title": "User",
                                               "type": "object",
                                               "properties": {
                                                 "id": {
                                                   "type": "integer",
                                                   "title": "Id"
                                                 },
                                                 "name": {
                                                   "type": "string",
                                                   "title": "Name"
                                                 },
                                                 "email": {
                                                   "type": "string",
                                                   "title": "Email"
                                                 },
                                                 "group": {
                                                   "type": "integer",
                                                   "title": "Group"
                                                 },
                                                 "dob": {
                                                   "type": "date",
                                                   "title": "Dob"
                                                 },
                                                 "salary": {
                                                   "type": "number",
                                                   "title": "Salary"
                                                 },
                                                 "active": {
                                                   "type": "boolean",
                                                   "default": false,
                                                   "title": "Active"
                                                 },
                                                 "bio": {
                                                   "type": "string",
                                                   "title": "Bio"
                                                 },
                                                 "country": {
                                                   "type": "string",
                                                   "default": "United States of America",
                                                   "title": "Country"
                                                 },
                                                 "preferences": {
                                                   "title": "Preferences"
                                                 },
                                                 "created_at": {
                                                   "type": "date-time",
                                                   "title": "Created at"
                                                 },
                                                 "updated_at": {
                                                   "type": "date-time",
                                                   "title": "Updated at"
                                                 }
                                               },
                                               "required": %w[
                                                 id
                                                 name
                                                 email
                                                 group
                                                 dob
                                                 salary
                                                 active
                                                 bio
                                                 country
                                                 preferences
                                                 created_at
                                                 updated_at
                                               ]
                                             })
  end
end
