# frozen_string_literal: true

require "spec_helper"

RSpec.describe Esquema::Model do
  class User < ActiveRecord::Base
    include Esquema::Model
  end

  let(:model) { User }

  after { Esquema.configuration.reset }

  it "returns a ruby hash representing the schema_model properties" do
    expect(model.json_schema).to include_json({
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
